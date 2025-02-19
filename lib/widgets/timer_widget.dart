import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_mqtt_demo/bloc/cubits/timer_cubit/timer_cubit.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({super.key});

  Future<void> _pickDateTime(BuildContext context, bool isStart) async {
    final timerCubit = context.read<TimerCubit>();
    DateTime current = isStart ? timerCubit.state.startTime : timerCubit.state.endTime;

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null || !context.mounted) return; // ✅ Ensure context is still valid

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current),
    );

    if (pickedTime == null || !context.mounted) return; // ✅ Ensure context is still valid

    DateTime newDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    if (isStart) {
      timerCubit.updateStartTime(newDateTime);
    } else {
      timerCubit.updateEndTime(newDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerCubit, TimerState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Select Timer', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 10.0),
            Text("Starts", style: Theme.of(context).textTheme.titleSmall),
            ElevatedButton(
              onPressed: () => _pickDateTime(context, true),
              child: Text("${state.startTime.month}-${state.startTime.day}-${state.startTime.year}"),
            ),
            const SizedBox(height: 20),
            Text("Ends", style: Theme.of(context).textTheme.titleSmall),
            ElevatedButton(
              onPressed: () => _pickDateTime(context, false),
              child: Text("${state.endTime.month}-${state.endTime.day}-${state.endTime.year}"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.read<TimerCubit>().confirmSelection(),
              child: const Text("Done"),
            ),
          ],
        );
      },
    );
  }
}
