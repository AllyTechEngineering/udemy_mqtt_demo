import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
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
        )) {
    // Listen for repository changes so that both UI and MQTT updates are handled
    _dataRepository.addListener(_onRepositoryChange);
  }

  // Called when the UI slider is adjusted
  void updatePwm(int value) {
    debugPrint('PwmCubit: updatePwm with value $value');
    final updatedState =
        _dataRepository.deviceState.copyWith(pwmDutyCycle: value);
    // This will publish the update (with publish: true by default)
    _dataRepository.updateDeviceState(updatedState);
    // Emit the new state locally so the UI can update immediately
    emit(state.copyWith(dutyCycle: value));
  }

  // Called when the UI toggle switch is used to turn PWM on/off
  void togglePwm() {
    debugPrint('PwmCubit: togglePwm');
    final newPwmOn = !_dataRepository.deviceState.pwmOn;
    final updatedState = _dataRepository.deviceState.copyWith(pwmOn: newPwmOn);
    _dataRepository.updateDeviceState(updatedState);
    emit(state.copyWith(isPwmOn: newPwmOn));
  }

  // This listener responds to any repository changes—whether triggered by the UI or by MQTT updates.
  void _onRepositoryChange() {
    final newDutyCycle = _dataRepository.deviceState.pwmDutyCycle;
    final newIsPwmOn = _dataRepository.deviceState.pwmOn;

    // If the duty cycle has changed, update the PWM service and emit the new state.
    if (newDutyCycle != state.dutyCycle) {
      debugPrint('PwmCubit: _onRepositoryChange updating dutyCycle to $newDutyCycle');
      _pwmService.updatePwmDutyCycle(newDutyCycle);
      emit(state.copyWith(dutyCycle: newDutyCycle));
    }

    // If the PWM on/off state has changed, update the PWM service and emit the new state.
    if (newIsPwmOn != state.isPwmOn) {
      debugPrint('PwmCubit: _onRepositoryChange updating isPwmOn to $newIsPwmOn');
      _pwmService.pwmSystemOnOff();
      emit(state.copyWith(isPwmOn: newIsPwmOn));
    }
  }

  @override
  Future<void> close() {
    _dataRepository.removeListener(_onRepositoryChange);
    return super.close();
  }
}
