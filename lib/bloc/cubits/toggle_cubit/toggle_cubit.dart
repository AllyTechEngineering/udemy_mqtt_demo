import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:udemy_mqtt_demo/bloc/data_repository/data_repository.dart';
import 'package:udemy_mqtt_demo/models/device_state_model.dart';
import 'package:udemy_mqtt_demo/services/gpio_services.dart';

part 'toggle_state.dart';

class ToggleCubit extends Cubit<ToggleState> {
  final DataRepository _dataRepository;
  final GpioService _gpioService;
  late final StreamSubscription<DeviceStateModel> _repoSubscription;

  ToggleCubit(this._dataRepository, this._gpioService)
      : super(ToggleState(
          toggleDeviceState: _dataRepository.deviceState.toggleDeviceState,
        )) {
    // Subscribe to the repository's stream.
    _repoSubscription = _dataRepository.deviceStateStream.listen((deviceState) {
      final newToggleState = deviceState.toggleDeviceState;
      // Only update hardware if the toggle state has actually changed.
      if (newToggleState != state.toggleDeviceState) {
        debugPrint(
            'ToggleCubit: deviceStateStream received new toggle state: $newToggleState');
        _gpioService.newToggleDeviceState();
        emit(ToggleState(toggleDeviceState: newToggleState));
      }
    });
  }

  // Called when the UI toggle switch is used.
  // This method only updates the repository; the stream subscription will then
  // propagate the updated state and update the hardware.
  void updateDeviceState() {
    debugPrint('ToggleCubit: updateDeviceState');
    final currentState = _dataRepository.deviceState.toggleDeviceState;
    final newState = !currentState;
    final updatedState =
        _dataRepository.deviceState.copyWith(toggleDeviceState: newState);
    _dataRepository.updateDeviceState(updatedState);
  }

  @override
  Future<void> close() {
    _repoSubscription.cancel();
    return super.close();
  }
}
