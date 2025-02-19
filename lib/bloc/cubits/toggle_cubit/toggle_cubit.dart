import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:udemy_mqtt_demo/bloc/data_repository/data_repository.dart';
import 'package:udemy_mqtt_demo/services/gpio_services.dart';

part 'toggle_state.dart';

class ToggleCubit extends Cubit<ToggleState> {
  final GpioService _gpioService;
  final DataRepository _dataRepository;

  ToggleCubit(this._dataRepository, this._gpioService)
      : super(ToggleState(
          toggleDeviceState: _dataRepository.deviceState.toggleDeviceState,
        )) {
    // Listen for repository changes and update state
    _dataRepository.addListener(_onRepositoryChange);
  }

  // Toggle state manually when user interacts
  void updateDeviceState() {
    debugPrint('ToggleCubit: updateDeviceState');
    final newState = !_dataRepository.deviceState.toggleDeviceState;
    final updatedState =
        _dataRepository.deviceState.copyWith(toggleDeviceState: newState);

    _dataRepository.updateDeviceState(updatedState);
    // Removed _gpioService.newToggleDeviceState() here to prevent duplicate toggling
    emit(state.copyWith(toggleDeviceState: newState));
  }

  // Listen for MQTT changes in DataRepository
  void _onRepositoryChange() {
    final newState = _dataRepository.deviceState.toggleDeviceState;
    debugPrint('ToggleCubit: _onRepositoryChange: $newState');
    // Prevent unnecessary state emissions
    if (newState != state.toggleDeviceState) {
      _gpioService.newToggleDeviceState();
      emit(state.copyWith(toggleDeviceState: newState));
    }
  }

  @override
  Future<void> close() {
    _dataRepository.removeListener(_onRepositoryChange);
    return super.close();
  }
}
