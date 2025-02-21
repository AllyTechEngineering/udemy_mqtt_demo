import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:udemy_mqtt_demo/bloc/data_repository/data_repository.dart';
import 'package:udemy_mqtt_demo/models/device_state_model.dart';
import 'package:udemy_mqtt_demo/services/gpio_services.dart';

part 'flash_state.dart';

class FlashCubit extends Cubit<FlashState> {
  final DataRepository _dataRepository;
  final GpioService _gpioService;
  late final StreamSubscription<DeviceStateModel> _repoSubscription;

  FlashCubit(this._dataRepository, this._gpioService)
      : super(FlashState(
          isFlashing: _dataRepository.deviceState.flashOn,
          flashRate: _dataRepository.deviceState.flashRate,
        )) {
    // Subscribe to the repository's broadcast stream.
    _repoSubscription = _dataRepository.deviceStateStream.listen((deviceState) {
      final newFlashRate = deviceState.flashRate;
      final newIsFlashing = deviceState.flashOn;
      debugPrint(
          'FlashCubit: deviceStateStream received: flashRate=$newFlashRate, isFlashing=$newIsFlashing');

      // Update the hardware: update flash rate always.
      _gpioService.updateDeviceFlashRate(newFlashRate);
      // If the on/off state has changed, update the flash system.
      if (newIsFlashing != state.isFlashing) {
        _gpioService.toggleFlashState();
      }
      // Emit the new state to update the UI.
      emit(FlashState(flashRate: newFlashRate, isFlashing: newIsFlashing));
    });
  }

  // UI method: update flash rate.
  void updateFlashRate(int value) {
    debugPrint('FlashCubit: updateFlashRate with value $value');
    final updatedState =
        _dataRepository.deviceState.copyWith(flashRate: value);
    _dataRepository.updateDeviceState(updatedState);
  }

  // UI method: toggle flash on/off.
  void toggleFlash() {
    debugPrint('FlashCubit: toggleFlash');
    final newFlashOn = !_dataRepository.deviceState.flashOn;
    final updatedState =
        _dataRepository.deviceState.copyWith(flashOn: newFlashOn);
    _dataRepository.updateDeviceState(updatedState);
  }

  @override
  Future<void> close() {
    _repoSubscription.cancel();
    return super.close();
  }
}
