import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_mqtt_demo/bloc/cubits/flash_cubit/flash_cubit.dart';

import 'package:udemy_mqtt_demo/utilities/constants.dart';
import 'package:udemy_mqtt_demo/utilities/custom_decorations.dart';

class FlashToggleSwitch extends StatelessWidget {
  const FlashToggleSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlashCubit, FlashState>(
      builder: (context, state) {
        return Container(
          width: Constants.kWidth,
          height: Constants.kHeight,
          padding: const EdgeInsets.all(4.0),
          decoration: CustomDecorations.gradientContainer(isActive: state.isFlashing),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.isFlashing ? Constants.kLabelFlashOn : Constants.kLabelFlashOff,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Switch(
                value: state.isFlashing,
                onChanged: (_) => context.read<FlashCubit>().toggleFlash(),
              ),
            ],
          ),
        );
      },
    );
  }
}

