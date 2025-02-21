import 'dart:io';

import 'package:dart_periphery/dart_periphery.dart';
import 'package:flutter/foundation.dart';

// import 'package:led_on_off_pwm/services/gpio_service.dart';
// Must follow the how to enabl e PWM in the Raspberry Pi
// Located on the readme page.
class PwmService {
  static final PwmService _instance = PwmService._internal();
  late PWM pwm0;
  late PWM pwm1;
  static bool systemOnOffState = true;

  factory PwmService() {
    return _instance;
  }

  PwmService._internal() {
    _initializePwm();
  }

  void _initializePwm() {
    try {
      _exportPwm(); // Ensure PWM0 is available before opening it
      pwm0 = PWM(2, 0);
      pwm1 = PWM(2, 1);
      _configurePwm(pwm0);
      _configurePwm(pwm1);
    } catch (e) {
      debugPrint('Error initializing PwmService: $e');
    }
  }

  void _configurePwm(PWM pwm) {
    pwm.setPeriodNs(10000000);
    pwm.setDutyCycleNs(0);
    pwm.enable();
    pwm.setPolarity(Polarity.pwmPolarityNormal);
  }

  /// Ensures PWM is exported before opening it
  void _exportPwm() {
    try {
      if (!File('/sys/class/pwm/pwmchip2/pwm0').existsSync()) {
        debugPrint('Exporting PWM0...');
        Process.runSync(
            'sh', ['-c', 'echo 0 > /sys/class/pwm/pwmchip2/export']);
        debugPrint('Exporting PWM1...');
        Process.runSync(
            'sh', ['-c', 'echo 1 > /sys/class/pwm/pwmchip2/export']);
        sleep(Duration(milliseconds: 500)); // Wait for the system to process
      }
    } catch (e) {
      debugPrint('Error exporting PWM0 or PWM1: $e');
    }
  }

  void updatePwmDutyCycle(int updateDutyCycle) {
    debugPrint('Updating PWM duty cycle to $updateDutyCycle%');
    if (systemOnOffState) {
      pwm0.setDutyCycleNs(updateDutyCycle * 100000);
      pwm1.setDutyCycleNs(updateDutyCycle * 100000);
    }
  }

  void pwmSystemOnOff() {
    debugPrint('Toggling PWM system on/off');
    systemOnOffState = !systemOnOffState;
    if (!systemOnOffState) {
      pwm0.disable();
      pwm1.disable();
    } else {
      pwm0.enable();
      pwm1.enable();
    }
  }

  //Disposal
  // Add all the enabled pwms to the dispose method
  void dispose() {
    for (var pwm in [pwm0, pwm1]) {
      pwm.disable();
      pwm.dispose();
    }
    debugPrint('PWM resources released');
  }
} // End of class PwmService
