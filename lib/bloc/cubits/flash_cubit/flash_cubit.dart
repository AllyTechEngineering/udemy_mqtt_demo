import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
        ));

  // ✅ Only updates flashRate
  void updateFlashRate(int value) {
    final updatedState = _dataRepository.deviceState.copyWith(flashRate: value);
    _dataRepository.updateDeviceState(updatedState);
    _gpioService.updateDeviceFlashRate(value);

    // ✅ Only emit the updated flashRate (Keep isFlashing unchanged)
    emit(state.copyWith(flashRate: value));
  }

  // ✅ Only updates isFlashing
  void toggleFlash() {
    final newState = !_dataRepository.deviceState.flashOn;
    final updatedState =
        _dataRepository.deviceState.copyWith(flashOn: newState);
    _dataRepository.updateDeviceState(updatedState);
    _gpioService.toggleFlashState();
    emit(state.copyWith(isFlashing: newState));
  }
}
