// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:udemy_led_demo/bloc/cubits/flash_cubit/flash_cubit.dart';
// import 'package:udemy_led_demo/bloc/data_repository/data_repository.dart';

// class TestFlashRateButton extends StatelessWidget {
//   const TestFlashRateButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final dataRepository = context.read<DataRepository>();
//     final flashCubit = context.read<FlashCubit>();

//     return ElevatedButton(
//       onPressed: () {
//         int newFlashRate = 750; // Simulated external data
//         dataRepository.updateDeviceState(
//           dataRepository.deviceState.copyWith(flashRate: newFlashRate),
//           flashCubit: flashCubit,
//         );
//       },
//       child: const Text("Simulate External Flash Rate Update"),
//     );
//   }
// }
