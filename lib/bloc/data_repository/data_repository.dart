// import 'package:flutter/foundation.dart';
// import 'package:udemy_led_demo/bloc/cubits/flash_cubit/flash_cubit.dart';
import 'package:udemy_mqtt_demo/models/device_state_model.dart';

class DataRepository {
  DeviceStateModel _deviceState = DeviceStateModel(
    pwmDutyCycle: 0,
    pwmOn: true,
    flashRate: 0,
    flashOn: true,
    timerStart: DateTime.now(),
    timerEnd: DateTime.now().add(const Duration(minutes: 1)),
    gpioSensorState: false,
    toggleDeviceState: false,
  );

  DataRepository();

  // Getter for current device state
  DeviceStateModel get deviceState => _deviceState;

  // Update state with a new model (used by Cubits)
  void updateDeviceState(DeviceStateModel newState) {
    _deviceState = newState;
    // debugPrint('Updated DeviceStateModel: ${_deviceState.toJson()}');
  }
}
