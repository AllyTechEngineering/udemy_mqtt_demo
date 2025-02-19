import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:udemy_mqtt_demo/bloc/data_repository/data_repository.dart';
import 'package:udemy_mqtt_demo/services/pwm_services.dart';
part 'pwm_state.dart';

class PwmCubit extends Cubit<PwmState> {
  final DataRepository _dataRepository;
  final PwmService _pwmService;

  PwmCubit(this._dataRepository, this._pwmService)
      : super(PwmState(
          dutyCycle: _dataRepository.deviceState.pwmDutyCycle,
          isPwmOn: _dataRepository.deviceState.pwmOn,
        ));

  void updatePwm(int value) {
    final updatedState =
        _dataRepository.deviceState.copyWith(pwmDutyCycle: value);
    _dataRepository.updateDeviceState(updatedState);
    _pwmService.updatePwmDutyCycle(value);
    emit(state.copyWith(dutyCycle: value));
  }
  void togglePwm() {
    final newState = !_dataRepository.deviceState.pwmOn;
    final updatedState = _dataRepository.deviceState.copyWith(pwmOn: newState);
    _dataRepository.updateDeviceState(updatedState);
    _pwmService.pwmSystemOnOff();
    emit(state.copyWith(isPwmOn: newState));
  }
}
