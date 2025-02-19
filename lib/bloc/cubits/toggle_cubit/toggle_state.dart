part of 'toggle_cubit.dart';

class ToggleState extends Equatable {
  final bool toggleDeviceState;
  const ToggleState({required this.toggleDeviceState});

  ToggleState copyWith({bool? toggleDeviceState}) {
    return ToggleState(
      toggleDeviceState: toggleDeviceState ?? this.toggleDeviceState,
    );
  }

  @override
  List<Object> get props => [toggleDeviceState];

  @override
  String toString() => 'ToggleState(toggleDeviceState: $toggleDeviceState)';
}

/*
class FlashState extends Equatable {
  final bool isFlashing;
  final int flashRate;

  const FlashState({required this.isFlashing, required this.flashRate});

  // ✅ copyWith allows updating only one value at a time
  FlashState copyWith({bool? isFlashing, int? flashRate}) {
    return FlashState(
      isFlashing: isFlashing ?? this.isFlashing,
      flashRate: flashRate ?? this.flashRate,
    );
  }

  @override
  List<Object> get props => [isFlashing, flashRate];
}
*/
