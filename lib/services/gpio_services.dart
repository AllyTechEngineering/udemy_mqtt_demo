import 'dart:async';
import 'package:dart_periphery/dart_periphery.dart';
import 'package:flutter/foundation.dart';
import 'package:udemy_mqtt_demo/utilities/constants.dart';

class GpioService {
  static final GpioService _instance = GpioService._internal();
  static Duration pollingDuration =
      const Duration(milliseconds: Constants.kPollingDuration);
  Timer? _pollingTimer;
  Timer? _flashTimer;
  late GPIO gpio5;
  late GPIO gpio6;
  late GPIO gpio22;
  late GPIO gpio16;
  late GPIO gpio27;
  static int flashRate = 0;

  // Use a map for managing boolean states
  final Map<String, bool> _gpioStates = {
    "directionState": true, // true = forward, false = backward
    "toggleDeviceState": false,
    "isInputDetected": false,
    "isPolling": false,
    "currentInputState": false,
    "isFlashing": true,
  };

  factory GpioService() => _instance;

  GpioService._internal() {
    _initializeGpios();
  }

  void _initializeGpios() {
    _initializeGpio(5, GPIOdirection.gpioDirOut, false, (gpio) => gpio5 = gpio);
    _initializeGpio(6, GPIOdirection.gpioDirOut, false, (gpio) => gpio6 = gpio);
    _initializeGpio(22, GPIOdirection.gpioDirOut, false, (gpio) => gpio22 = gpio);
    _initializeGpio(27, GPIOdirection.gpioDirOut, false, (gpio) => gpio27 = gpio);
    _initializeGpio(16, GPIOdirection.gpioDirIn, null, (gpio) {
      gpio16 = gpio;
      bool initialInput = gpio16.read();
      setState("isInputDetected", initialInput);
      setLedState(initialInput);
      debugPrint('gpio16 initial state: $initialInput');
    });
  }

  void _initializeGpio(int pin, GPIOdirection direction, bool? initialState,
      Function(GPIO) assignGpio) {
    try {
      GPIO gpio = GPIO(pin, direction, 0);
      if (initialState != null) {
        gpio.write(initialState);
      }
      assignGpio(gpio);
      debugPrint('GPIO $pin initialized');
    } on Exception catch (e) {
      debugPrint('Error initializing GPIO $pin: $e');
    }
  }

  // Getters for boolean states
  bool get directionState => _gpioStates["directionState"]!;
  bool get toggleDeviceState => _gpioStates["toggleDeviceState"]!;
  bool get isInputDetected => _gpioStates["isInputDetected"]!;
  bool get isPolling => _gpioStates["isPolling"]!;
  bool get currentInputState => _gpioStates["currentInputState"]!;
  bool get isFlashing => _gpioStates["isFlashing"]!;

  // Methods to modify state values
  void setState(String key, bool value) {
    _gpioStates[key] = value;
  }

  Stream<bool> pollInputState() async* {
    // Read and yield the initial state
    bool lastState = gpio16.read();
    setState("isInputDetected", lastState);
    setLedState(lastState);
    yield lastState; // Yield the initial state immediately

    // Continuously poll gpio16 without blocking the main thread
    while (true) {
      await Future.delayed(pollingDuration);
      bool newState = gpio16.read();
      if (newState != lastState) {
        lastState = newState;
        setState("isInputDetected", newState);
        setLedState(newState);
        yield newState;
      }
    }
  }

  // Sensor input LED control
  void setLedState(bool state) {
    gpio27.write(state);
  }

  void stopInputPolling() {
    _pollingTimer?.cancel();
    setState("isPolling", false);
  }

  // GPIO Output Control
  void newToggleDeviceState() {
    // debugPrint('Toggling device state');
    final bool newState = !toggleDeviceState; // Toggle the state
    setState("toggleDeviceState", newState);
    // debugPrint('Toggle Switch State: $newState');
    gpio5.write(newState);
  }

  void setRelayState(bool state) {
    gpio6.write(state);
  }

  void pwmMotorServiceDirection() {
    gpio5.write(true);
    gpio6.write(true);
    Future.delayed(const Duration(milliseconds: 500), () {
      setState("directionState", !directionState);
      gpio5.write(!directionState);
      gpio6.write(directionState);
    });
  }

  void toggleFlashState() {
    debugPrint('Toggling flash state');
    bool currentState = isFlashing;
    setState("isFlashing", !currentState);
    updateDeviceFlashRate(flashRate);
  }

  void updateDeviceFlashRate(int newFlashRate) {
    debugPrint('Updating flash rate to $newFlashRate');
    flashRate = newFlashRate;
    _flashTimer?.cancel(); // Cancel any existing timer

    if (newFlashRate == 0 || !isFlashing) {
      gpio22.write(false); // Ensure LED is off if not flashing
    } else {
      _flashTimer = Timer.periodic(Duration(milliseconds: flashRate), (_) {
        gpio22.write(!gpio22.read()); // Toggle LED state
      });
    }
  }

  // Disposal
  void dispose() {
    _pollingTimer?.cancel();
    _flashTimer?.cancel();

    // Ensure all GPIOs are set to a safe state before disposing
    for (var gpio in [gpio5, gpio6, gpio22, gpio27]) {
      gpio.write(false);
    }

    // Dispose all GPIOs
    for (var gpio in [gpio5, gpio6, gpio22, gpio16, gpio27]) {
      gpio.dispose();
    }

    debugPrint('GPIO resources released');
  }
}
