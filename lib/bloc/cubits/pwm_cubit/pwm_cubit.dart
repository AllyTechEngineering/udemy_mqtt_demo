import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:udemy_mqtt_demo/bloc/data_repository/data_repository.dart';
import 'package:udemy_mqtt_demo/models/device_state_model.dart';
import 'package:udemy_mqtt_demo/services/pwm_services.dart';
part 'pwm_state.dart';

class PwmCubit extends Cubit<PwmState> {
  final DataRepository _dataRepository;
  final PwmService _pwmService;
  late final StreamSubscription<DeviceStateModel> _repoSubscription;

  PwmCubit(this._dataRepository, this._pwmService)
      : super(PwmState(
          dutyCycle: _dataRepository.deviceState.pwmDutyCycle,
          isPwmOn: _dataRepository.deviceState.pwmOn,
        )) {
    // Subscribe to the repository's state stream.
    _repoSubscription = _dataRepository.deviceStateStream.listen((deviceState) {
      final newDutyCycle = deviceState.pwmDutyCycle;
      final newIsPwmOn = deviceState.pwmOn;
      debugPrint(
          'PwmCubit: deviceStateStream received: dutyCycle=$newDutyCycle, isPwmOn=$newIsPwmOn');

      // Update the PWM hardware with the new duty cycle.
      _pwmService.updatePwmDutyCycle(newDutyCycle);
      // If the on/off state has changed, update the PWM system.
      if (newIsPwmOn != state.isPwmOn) {
        _pwmService.pwmSystemOnOff();
      }
      // Emit the new state so that the UI is updated.
      emit(PwmState(dutyCycle: newDutyCycle, isPwmOn: newIsPwmOn));
    });
  }

  // Called when the UI slider is adjusted.
  // This method only updates the repository state; the stream subscription
  // will later trigger the hardware update and emit the new state.
  void updatePwm(int value) {
    debugPrint('PwmCubit: updatePwm with value $value');
    final updatedState =
        _dataRepository.deviceState.copyWith(pwmDutyCycle: value);
    _dataRepository.updateDeviceState(updatedState);
  }

  // Called when the UI toggle switch is used to turn PWM on/off.
  // This method only updates the repository state; the stream subscription
  // will later trigger the hardware update and emit the new state.
  void togglePwm() {
    debugPrint('PwmCubit: togglePwm');
    final newPwmOn = !_dataRepository.deviceState.pwmOn;
    final updatedState = _dataRepository.deviceState.copyWith(pwmOn: newPwmOn);
    _dataRepository.updateDeviceState(updatedState);
  }

  @override
  Future<void> close() {
    _repoSubscription.cancel();
    return super.close();
  }
}
