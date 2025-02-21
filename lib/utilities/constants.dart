import 'package:flutter/material.dart';

class Constants {
  // https://colorhunt.co/palettes/sea
  // https://colorhunt.co/palette/27445d497d7471bbb2efe9d5
// - Darkest: `0xFF27445D`
// - Dark: `0xFF497D74`
// - Medium: `0xFF71BBB2`
// - Light: `0xFFEFE9D5`
  static const String kTitle = 'Device Demo';
  static const String kLabelFlashOn = 'Flash On';
  static const String kLabelFlashOff = 'Flash Off';
  static const String kOn = 'PWM: On';
  static const String kOff = 'PWM: Off';
  static const String kLabel = 'Rate:';
  static const String kPwmLabel = 'PWM:';
  static const String kStatusFalse = 'Sensor: Low';
  static const String kStatusTrue = 'Sensor: High';
  static const String kToggleTrue = 'Device On';
  static const String kToggleFalse = 'Device Off:';
  static const int kFlashRate = 500; // Flash rate in milliseconds
  static const int kPollingDuration = 500; // Polling duration in milliseconds
  static const double kWidth = 100.0; // Width of container
  static const double kHeight = 100.0; // Height of container
  static const double kSizedBoxHeight = 300.0;
  static const double kSizedBoxWidth = 800.0;
  static const double kSmallBoxHeight = 60.0;
  static const double kSmallBoxWidth = 130.0;
  static const double kLargeBoxHeight = 60.0;
  static const double kLargeBoxWidth = 150.0;
  static const Color kColorTrue = Colors.green;
  static const Color kColorFalse = Colors.red;
  static const Color kColorDarkest = Color(0xFF27445D);
  static const Color kColorDark = Color(0xFF497D74);
  static const Color kColorMedium = Color(0xFF71BBB2);
  static const Color kColorLight = Color(0xFFEFE9D5);
   static const Color kColorDarkestRed = Color(0xFF872341);
  static const Color kColorDarkRed = Color(0xFFBE3144);
  // theme constants
  static const double kToolbarTextStyle = 16.0;
  static const double kTitleTextStyle = 16.0;
  static const double kActionsIconThemeIconSize = 24.0;
  static const double kBodyLargeFontSize = 18.0;
  static const double kBodyMediumFontSize = 16.0;
  static const double kBodySmallFontSize = 14.0;
  static const double kDisplayLargeFontSize = 18.0;
  static const double kDisplayMediumFontSize = 18.0;
  static const double kDisplaySmallFontSize = 12.0;
  static const double kTitleLargeFontSize = 22.0;
  static const double kTitleMediumFontSize = 20.0;
  static const double kTitleSmallFontSize = 18.0;
  static const double kIconThemeIconSize = 24.0;
}