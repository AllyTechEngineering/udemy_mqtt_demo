import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:udemy_mqtt_demo/models/device_state_model.dart';
import 'package:udemy_mqtt_demo/services/mqtt_service.dart';

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

  late MqttService mqttService;

  // Broadcast stream controller so multiple listeners (cubits) can subscribe.
  final _stateController = StreamController<DeviceStateModel>.broadcast();

  DataRepository() {
    _initializeMqttService();
  }

  void _initializeMqttService() {
    mqttService = MqttService(this);
    mqttService.connect();
  }

  // Expose the device state as a stream.
  Stream<DeviceStateModel> get deviceStateStream => _stateController.stream;

  // Getter for the current device state.
  DeviceStateModel get deviceState => _deviceState;

  // Update the state and add the new state to the stream.
  void updateDeviceState(DeviceStateModel newState, {bool publish = true}) {
    // Prevent unnecessary updates.
    if (_deviceState == newState) return;
    _deviceState = newState;
debugPrint('DataRepository: updateDeviceState called with new state: $newState');
    if (publish) {
      mqttService.publishDeviceState(newState);
    }

    // Emit the new state so all subscribers get updated.
    _stateController.add(newState);
  }

  // Dispose the stream when no longer needed.
  void dispose() {
    _stateController.close();
  }
}
