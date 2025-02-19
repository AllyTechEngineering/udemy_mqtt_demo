
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:udemy_mqtt_demo/bloc/data_repository/data_repository.dart';
import 'package:udemy_mqtt_demo/services/timer_services.dart';
part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  final DataRepository _dataRepository;
  final TimerService _timerService;

  TimerCubit(this._dataRepository, this._timerService)
      : super(TimerState(
          _dataRepository.deviceState.timerStart,
          _dataRepository.deviceState.timerEnd,
        ));

  void updateStartTime(DateTime startTime) {
    final updatedState = _dataRepository.deviceState.copyWith(timerStart: startTime);
    _dataRepository.updateDeviceState(updatedState);
    emit(TimerState(startTime, _dataRepository.deviceState.timerEnd));
  }

  void updateEndTime(DateTime endTime) {
    final updatedState = _dataRepository.deviceState.copyWith(timerEnd: endTime);
    _dataRepository.updateDeviceState(updatedState);
    emit(TimerState(_dataRepository.deviceState.timerStart, endTime));
  }

  void confirmSelection() {
    _timerService.scheduleGpioTrigger(
      _dataRepository.deviceState.timerStart,
      _dataRepository.deviceState.timerEnd,
    );
  }
}
