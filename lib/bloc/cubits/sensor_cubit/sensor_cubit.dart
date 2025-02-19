import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// import 'package:flutter/foundation.dart';
import 'package:udemy_mqtt_demo/bloc/data_repository/data_repository.dart';
import 'package:udemy_mqtt_demo/services/gpio_services.dart';

part 'sensor_state.dart';

class SensorCubit extends Cubit<SensorState> {
  final GpioService _gpioService;
  final DataRepository _dataRepository;

  SensorCubit(this._dataRepository, this._gpioService)
      : super(SensorState(_gpioService.isInputDetected)) {
    // debugPrint(
    //     "SensorCubit initialized with state: ${_gpioService.isInputDetected}");
    _gpioService.startInputPolling((newState) {
      final updatedState =
          _dataRepository.deviceState.copyWith(gpioSensorState: newState);
      _dataRepository.updateDeviceState(updatedState);
      emit(SensorState(newState));
    });
  }
}
