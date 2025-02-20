import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:udemy_mqtt_demo/bloc/data_repository/data_repository.dart';
import 'package:udemy_mqtt_demo/services/gpio_services.dart';

part 'flash_state.dart';

class FlashCubit extends Cubit<FlashState> {
  final DataRepository _dataRepository;
  final GpioService _gpioService;

  FlashCubit(this._dataRepository, this._gpioService)
      : super(FlashState(
          isFlashing: _dataRepository.deviceState.flashOn,
          flashRate: _dataRepository.deviceState.flashRate,
        )){
          // Listen for repository changes so that both UI and MQTT updates are handled
          _dataRepository.addListener(_onRepositoryChange);
        }

  void updateFlashRate(int value) {
    final updatedState = _dataRepository.deviceState.copyWith(flashRate: value);
    _dataRepository.updateDeviceState(updatedState);
    _gpioService.updateDeviceFlashRate(value);
    // Emit the new state locally so the UI can update immediately
    emit(state.copyWith(flashRate: value));
  }

  // ✅ Only updates isFlashing
  void toggleFlash() {
    final newState = !_dataRepository.deviceState.flashOn;
    final updatedState =
        _dataRepository.deviceState.copyWith(flashOn: newState);
    _dataRepository.updateDeviceState(updatedState);
    emit(state.copyWith(isFlashing: newState));
  }
  // This listener responds to any repository changes—whether triggered by the UI or by MQTT updates.
  void _onRepositoryChange() {
    final newFlashRate = _dataRepository.deviceState.flashRate;
    final newIsFlashOn = _dataRepository.deviceState.flashOn;

    // If the flash rate has changed, update the GPIO service and emit the new state.
    if (newFlashRate != state.flashRate) {
      debugPrint('FlashCubit: _onRepositoryChange updating flash rate to $newFlashRate');
      _gpioService.updateDeviceFlashRate(newFlashRate);
      emit(state.copyWith(flashRate: newFlashRate));
    }

    // If the Flash on/off state has changed, update the GPIO service and emit the new state.
    if (newIsFlashOn != state.isFlashing) {
      debugPrint('FlashCubit: _onRepositoryChange updating isFlashing to $newIsFlashOn');
      _gpioService.toggleFlashState();
      emit(state.copyWith(isFlashing: newIsFlashOn));
    }
  }

  @override
  Future<void> close() {
    _dataRepository.removeListener(_onRepositoryChange);
    return super.close();
  }

}
