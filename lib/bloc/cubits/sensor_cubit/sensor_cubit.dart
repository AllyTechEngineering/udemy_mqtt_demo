import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:udemy_mqtt_demo/bloc/data_repository/data_repository.dart';
import 'package:udemy_mqtt_demo/services/gpio_services.dart';

part 'sensor_state.dart';

class SensorCubit extends Cubit<SensorState> {
  final GpioService _gpioService;
  final DataRepository _dataRepository;
  late final StreamSubscription<bool> _sensorSubscription;

  SensorCubit(this._dataRepository, this._gpioService)
      : super(SensorState(_gpioService.isInputDetected)) {
    // Listen for repository changes (e.g. MQTT updates)
    _dataRepository.addListener(_onRepositoryChange);
    
    // Subscribe to the stream-based polling of gpio16
    _sensorSubscription = _gpioService.pollInputState().listen((newState) {
      // Update the repository state when gpio16 changes
      final updatedState = _dataRepository.deviceState.copyWith(gpioSensorState: newState);
      _dataRepository.updateDeviceState(updatedState);
      emit(SensorState(newState));
    });
  }

  // This listener is triggered when the repository changes (e.g. via MQTT)
  void _onRepositoryChange() {
    final newState = _dataRepository.deviceState.gpioSensorState;
    if (newState != state.isDetected) {
      // Optionally add a debug print to trace repository updates
      _gpioService.setLedState(newState);
      debugPrint('SensorCubit: _onRepositoryChange: $newState');
      emit(SensorState(newState));
    }
  }

  @override
  Future<void> close() {
    _sensorSubscription.cancel();
    _dataRepository.removeListener(_onRepositoryChange);
    return super.close();
  }
}
