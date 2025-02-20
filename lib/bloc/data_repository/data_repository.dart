import 'package:flutter/foundation.dart';
import 'package:udemy_mqtt_demo/models/device_state_model.dart';
import 'package:udemy_mqtt_demo/services/mqtt_service.dart';

class DataRepository extends ChangeNotifier {
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

  DataRepository() {
    _initializeMqttService();
  }

  void _initializeMqttService() {
    mqttService = MqttService(this);
    mqttService.connect();
  }

  // Getter for current device state
  DeviceStateModel get deviceState => _deviceState;

  // Update state and notify Cubits
  void updateDeviceState(DeviceStateModel newState, {bool publish = true}) {
    // Prevent unnecessary updates
    if (_deviceState == newState) {
      return;
    }

    _deviceState = newState;

    if (publish) {
      mqttService.publishDeviceState(newState);
    }

    notifyListeners();
  }
}
