import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:udemy_mqtt_demo/bloc/data_repository/data_repository.dart';
import 'package:udemy_mqtt_demo/services/timer_services.dart';
part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  final DataRepository _dataRepository;
  final TimerService _timerService;
  late final StreamSubscription _repoSubscription;

  TimerCubit(this._dataRepository, this._timerService)
      : super(TimerState(
          _dataRepository.deviceState.timerStart,
          _dataRepository.deviceState.timerEnd,
        )) {
    // Subscribe to the repository's state stream.
    _repoSubscription = _dataRepository.deviceStateStream.listen((deviceState) {
      final newStart = deviceState.timerStart;
      final newEnd = deviceState.timerEnd;
      // Emit a new TimerState when timerStart or timerEnd changes.
      emit(TimerState(newStart, newEnd));
    });
  }

  // UI method to update the start time.
  // This method only updates the repository; the repository stream will then emit the new state.
  void updateStartTime(DateTime startTime) {
    final updatedState = _dataRepository.deviceState.copyWith(timerStart: startTime);
    _dataRepository.updateDeviceState(updatedState);
  }

  // UI method to update the end time.
  // This method only updates the repository; the repository stream will then emit the new state.
  void updateEndTime(DateTime endTime) {
    final updatedState = _dataRepository.deviceState.copyWith(timerEnd: endTime);
    _dataRepository.updateDeviceState(updatedState);
  }

  // Called when the user confirms their selection.
  // This method triggers the TimerService to schedule the GPIO trigger.
  void confirmSelection() {
    _timerService.scheduleGpioTrigger(
      _dataRepository.deviceState.timerStart,
      _dataRepository.deviceState.timerEnd,
    );
  }

  @override
  Future<void> close() {
    _repoSubscription.cancel();
    return super.close();
  }
}
