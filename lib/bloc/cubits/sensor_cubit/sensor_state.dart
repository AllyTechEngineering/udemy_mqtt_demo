part of 'sensor_cubit.dart';

class SensorState extends Equatable {
  final bool isDetected;

  const SensorState(this.isDetected);

  @override
  List<Object> get props => [isDetected];
}
