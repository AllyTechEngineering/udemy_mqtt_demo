import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:udemy_mqtt_demo/bloc/data_repository/data_repository.dart';
import 'package:udemy_mqtt_demo/models/device_state_model.dart';
import 'package:udemy_mqtt_demo/services/gpio_services.dart';

part 'sensor_state.dart';

class SensorCubit extends Cubit<SensorState> {
  final GpioService _gpioService;
  final DataRepository _dataRepository;
  late final StreamSubscription<DeviceStateModel> _repoSubscription;
  late final StreamSubscription<bool> _sensorSubscription;

  SensorCubit(this._dataRepository, this._gpioService)
      : super(SensorState(_gpioService.isInputDetected)) {
    // Subscribe to the repository stream so that any update (e.g. via MQTT)
    // causes the cubit to emit a new sensor state and update the LED.
    _repoSubscription =
        _dataRepository.deviceStateStream.listen((deviceState) {
      final sensorValue = deviceState.gpioSensorState;
      _gpioService.setLedState(sensorValue);
      emit(SensorState(sensorValue));
    });

    // Also subscribe to the GPIO polling stream.
    // When the sensor reading changes, update the repository.
    _sensorSubscription = _gpioService.pollInputState().listen((newValue) {
      final updatedState =
          _dataRepository.deviceState.copyWith(gpioSensorState: newValue);
      _dataRepository.updateDeviceState(updatedState);
      // The repository stream subscription will then update the cubit.
    });
  }

  @override
  Future<void> close() {
    _repoSubscription.cancel();
    _sensorSubscription.cancel();
    return super.close();
  }
}
