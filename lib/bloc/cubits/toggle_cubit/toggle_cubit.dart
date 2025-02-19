import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:udemy_mqtt_demo/bloc/data_repository/data_repository.dart';
import 'package:udemy_mqtt_demo/services/gpio_services.dart';

part 'toggle_state.dart';

class ToggleCubit extends Cubit<ToggleState> {
  final GpioService _gpioService;
  final DataRepository _dataRepository;
  ToggleCubit(this._dataRepository, this._gpioService)
      : super(ToggleState(
          toggleDeviceState: _dataRepository.deviceState.toggleDeviceState,
        ));
  void updateDeviceState() {
    final newState = !_dataRepository.deviceState.toggleDeviceState;
    final updatedState =
        _dataRepository.deviceState.copyWith(toggleDeviceState: newState);
    _dataRepository.updateDeviceState(updatedState);
    _gpioService.newToggleDeviceState();
    emit(state.copyWith(toggleDeviceState: newState));
  }
}