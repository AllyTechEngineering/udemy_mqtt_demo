import 'package:equatable/equatable.dart';

class DeviceStateModel extends Equatable {
  final int pwmDutyCycle;
  final bool pwmOn;
  final int flashRate;
  final bool flashOn;
  final DateTime timerStart;
  final DateTime timerEnd;
  final bool gpioSensorState;
  final bool toggleDeviceState;

  const DeviceStateModel({
    required this.pwmDutyCycle,
    required this.pwmOn,
    required this.flashRate,
    required this.flashOn,
    required this.timerStart,
    required this.timerEnd,
    required this.gpioSensorState,
    required this.toggleDeviceState,
  });

  // Create a copy of the model with optional changes
  DeviceStateModel copyWith({
    int? pwmDutyCycle,
    bool? pwmOn,
    int? flashRate,
    bool? flashOn,
    DateTime? timerStart,
    DateTime? timerEnd,
    bool? gpioSensorState,
    bool? toggleDeviceState,
  }) {
    return DeviceStateModel(
      pwmDutyCycle: pwmDutyCycle ?? this.pwmDutyCycle,
      pwmOn: pwmOn ?? this.pwmOn,
      flashRate: flashRate ?? this.flashRate,
      flashOn: flashOn ?? this.flashOn,
      timerStart: timerStart ?? this.timerStart,
      timerEnd: timerEnd ?? this.timerEnd,
      gpioSensorState: gpioSensorState ?? this.gpioSensorState,
      toggleDeviceState: toggleDeviceState ?? this.toggleDeviceState,
    );
  }

  // Convert to JSON for MQTT integration
  Map<String, dynamic> toJson() {
    return {
      "pwmDutyCycle": pwmDutyCycle,
      "pwmOn": pwmOn,
      "flashRate": flashRate,
      "flashOn": flashOn,
      "timerStart": timerStart.toIso8601String(),
      "timerEnd": timerEnd.toIso8601String(),
      "gpioSensorState": gpioSensorState,
      "toggleDeviceState": toggleDeviceState,
    };
  }

  // Create from JSON (for MQTT receiving)
  factory DeviceStateModel.fromJson(Map<String, dynamic> json) {
    return DeviceStateModel(
      pwmDutyCycle: json["pwmDutyCycle"],
      pwmOn: json["pwmOn"],
      flashRate: json["flashRate"],
      flashOn: json["flashOn"],
      timerStart: DateTime.parse(json["timerStart"]),
      timerEnd: DateTime.parse(json["timerEnd"]),
      gpioSensorState: json["gpioSensorState"],
      toggleDeviceState: json["toggleDeviceState"],
    );
  }

  @override
  List<Object> get props => [
        pwmDutyCycle,
        pwmOn,
        flashRate,
        flashOn,
        timerStart,
        timerEnd,
        gpioSensorState,
        toggleDeviceState,
      ];
}
