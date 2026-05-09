import 'package:flutter/material.dart';


class BuildSnackBar {
  static const _duration = 3;
  static const _borderRadius = 10.0;

  static SnackBar build(String message, Color backgroundColor) {
    return SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      duration: const Duration(seconds: _duration),
    );
  }
}