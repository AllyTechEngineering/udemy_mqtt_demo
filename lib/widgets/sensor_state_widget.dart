import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_mqtt_demo/bloc/cubits/sensor_cubit/sensor_cubit.dart';
import 'package:udemy_mqtt_demo/utilities/constants.dart';
import 'package:udemy_mqtt_demo/utilities/custom_decorations.dart';

class SensorStateWidget extends StatelessWidget {
  const SensorStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SensorCubit, SensorState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: Constants.kWidth,
            height: Constants.kHeight,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(4.0),
            decoration: CustomDecorations.gradientContainer(isActive: state.isDetected),
            child: Text(
              state.isDetected ? Constants.kStatusTrue : Constants.kStatusFalse,
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}
