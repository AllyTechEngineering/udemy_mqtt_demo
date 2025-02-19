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
    "toggleDeviceState": true,
    "isInputDetected": false,
    "isPolling": false,
    "currentInputState": false,
    "isFlashing": true,
  };

  factory GpioService() => _instance;

  GpioService._internal() {
    try {
      gpio5 = GPIO(5, GPIOdirection.gpioDirOut, 0);
      gpio5.write(false);
      // debugPrint('gpio5 Initialized ${gpio5.getGPIOinfo()}');
    } on Exception catch (e) {
      debugPrint('Error initializing gpio5: $e');
    }
    try {
      gpio6 = GPIO(6, GPIOdirection.gpioDirOut, 0);
      gpio6.write(false);
      // debugPrint('gpio6 Initialized ${gpio6.getGPIOinfo()}');
    } on Exception catch (e) {
      debugPrint('Error initializing gpio6: $e');
    }
    try {
      gpio22 = GPIO(22, GPIOdirection.gpioDirOut, 0);
      gpio22.write(false);
      // debugPrint('gpio22 Initialized ${gpio22.getGPIOinfo()}');
    } on Exception catch (e) {
      debugPrint('Error initializing gpio22: $e');
    }
    try {
      gpio16 = GPIO(16, GPIOdirection.gpioDirIn, 0);
      gpio16.read();
      // debugPrint('gpio16 Initialized ${gpio16.getGPIOinfo()}');
    } on Exception catch (e) {
      debugPrint('Error initializing gpio16: $e');
    }
    try {
      gpio27 = GPIO(27, GPIOdirection.gpioDirOut, 0);
      gpio27.write(false);
      // debugPrint('gpio27 Initialized ${gpio27.getGPIOinfo()}');
    } on Exception catch (e) {
      debugPrint('Error initializing gpio27: $e');
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

  // void checkBuildMode() {
  //   if (kDebugMode) {
  //     debugPrint('Running in debug mode');
  //   } else if (kReleaseMode) {
  //     debugPrint('Running in release mode');
  //   } else if (kProfileMode) {
  //     debugPrint('Running in profile mode');
  //   }
  // }

  // GPIO Input Polling
  void startInputPolling(Function(bool) onData) {
    if (isPolling) return;
    setState("isPolling", true);

    _pollingTimer = Timer.periodic(pollingDuration, (_) {
      bool newState = gpio16.read();
      if (newState != isInputDetected) {
        setState("isInputDetected", newState);
        onData(newState);
        setLedState(newState);
      }
    });
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
    // debugPrint('First state ${_gpioStates["toggleDeviceState"]}');
    final bool newState = toggleDeviceState;
    setState("toggleDeviceState", newState);
       debugPrint('Toggle Switch State: $newState');
    gpio5.write(newState);
    setState("toggleDeviceState", !toggleDeviceState);
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
    bool currentState = isFlashing;
    setState("isFlashing", !currentState);
    updateDeviceFlashRate(flashRate);
  }

  void updateDeviceFlashRate(int newFlashRate) {
    flashRate = newFlashRate;
    if (newFlashRate == 0 || !isFlashing) {
      _flashTimer?.cancel();
      gpio22.write(false);
    } else {
      _flashTimer?.cancel();
      _flashTimer = Timer.periodic(Duration(milliseconds: flashRate), (_) {
        gpio22.write(!gpio22.read()); // Toggle LED state
      });
    }
  }

  // Disposal
  void dispose() {
    _pollingTimer?.cancel();
    _flashTimer?.cancel();

    gpio5.write(false);
    gpio6.write(false);
    gpio22.write(false);
    gpio27.write(false);

    gpio5.dispose();
    gpio6.dispose();
    gpio22.dispose();
    gpio16.dispose();
    gpio27.dispose();

    debugPrint('GPIO resources released');
  }
}
