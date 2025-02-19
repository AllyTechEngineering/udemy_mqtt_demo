import 'package:flutter/material.dart';
import 'package:udemy_mqtt_demo/utilities/constants.dart';

class CustomButtonDecorations {
  static BoxDecoration gradientContainer() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [Constants.kColorDarkest, Constants.kColorMedium],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(90), // Replaces withOpacity
          offset: const Offset(4, 4),
          blurRadius: 3,
        ),
      ],
    );
  }
}