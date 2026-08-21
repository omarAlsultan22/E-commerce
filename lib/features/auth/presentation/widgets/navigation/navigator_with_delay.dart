import 'package:flutter/material.dart';
import '../../../../../core/constants/app_durations.dart';


class NavigatorWithDelay {
  static void build({
    required Widget link,
    required BuildContext context,
  }) {
    Future.delayed(AppDurations.seconds, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => link
        ),
      );
    });
  }
}