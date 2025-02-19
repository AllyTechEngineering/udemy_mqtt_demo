
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

  DataRepository() {
    mqttService = MqttService(this);
    mqttService.connect();
  }

  // Getter for current device state
  DeviceStateModel get deviceState => _deviceState;

  // Update state with a new model and send to MQTT
  void updateDeviceState(DeviceStateModel newState) {
    _deviceState = newState;
    mqttService.publishDeviceState(newState);
  }
}
