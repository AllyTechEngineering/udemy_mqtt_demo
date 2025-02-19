part of 'flash_cubit.dart';

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

