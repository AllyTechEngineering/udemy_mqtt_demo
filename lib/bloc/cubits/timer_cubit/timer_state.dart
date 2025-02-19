part of 'timer_cubit.dart';

class TimerState extends Equatable {
  final DateTime startTime;
  final DateTime endTime;

  const TimerState(this.startTime, this.endTime);

  @override
  List<Object> get props => [startTime, endTime];
}
