import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_mqtt_demo/bloc/cubits/pwm_cubit/pwm_cubit.dart';
import 'package:udemy_mqtt_demo/utilities/constants.dart';

class PwmSlider extends StatelessWidget {
  const PwmSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PwmCubit, PwmState>(
      builder: (context, state) {
        return SizedBox(
          height: Constants.kSizedBoxHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: Constants.kSmallBoxHeight,
                width: Constants.kSmallBoxWidth,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Constants.kColorDarkest, Constants.kColorMedium],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black.withAlpha(90), // Replaces withOpacity
                      offset: const Offset(4, 4),
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: Text(
                  "PWM\nDuty Cycle: ${state.dutyCycle}%",
                  style: Theme.of(context).textTheme.bodySmall,textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 10,
                    // thumbShape: const RectangularSliderThumbShape(),
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 20),
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 16),
                    tickMarkShape: const RoundSliderTickMarkShape(),
                    activeTickMarkColor: Colors.white,
                    inactiveTickMarkColor: Colors.black,
                    inactiveTrackColor: Colors.grey,
                    activeTrackColor: Colors.blueGrey,
                    thumbColor: Constants.kColorDarkest,
                    valueIndicatorColor: Colors.blueGrey,
                    valueIndicatorTextStyle:
                        const TextStyle(color: Colors.white),
                  ),
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Slider(
                      value: state.dutyCycle.toDouble(),
                      min: 0,
                      max: 100,
                      divisions: 10,
                      label: "${state.dutyCycle}%",
                      onChanged: (value) {
                        context.read<PwmCubit>().updatePwm(value.toInt());
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
