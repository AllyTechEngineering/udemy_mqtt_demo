import 'dart:async';
import 'package:flutter/material.dart';
import 'package:udemy_mqtt_demo/services/gpio_services.dart';


class TimerService {
  static final TimerService _instance = TimerService._internal();
  final GpioService _gpioService = GpioService();
  Timer? _startTimer;
  Timer? _endTimer;

  factory TimerService() => _instance;

  TimerService._internal();

  void scheduleGpioTrigger(DateTime startTime, DateTime endTime) {
    debugPrint('Scheduling GPIO trigger from $startTime to $endTime');
    final now = DateTime.now();

    // Cancel any existing timers
    _startTimer?.cancel();
    _endTimer?.cancel();

    if (startTime.isAfter(now)) {
      final startDuration = startTime.difference(now);
      debugPrint('Relay will turn ON in $startDuration');
      
      _startTimer = Timer(startDuration, () {
        _gpioService.setRelayState(true); // Turn relay ON
        _scheduleEndTimer(endTime);
      });
    } else {
      debugPrint('Start time is in the past. Relay will not be scheduled.');
    }
  }

  void _scheduleEndTimer(DateTime endTime) {
    final now = DateTime.now();
    if (endTime.isAfter(now)) {
      final endDuration = endTime.difference(now);
      debugPrint('Relay will turn OFF in $endDuration');

      _endTimer = Timer(endDuration, () {
        _gpioService.setRelayState(false); // Turn relay OFF
      });
    } else {
      debugPrint('End time is in the past. Relay will not be scheduled.');
    }
  }

  void cancelTimers() {
    _startTimer?.cancel();
    _endTimer?.cancel();
  }
}