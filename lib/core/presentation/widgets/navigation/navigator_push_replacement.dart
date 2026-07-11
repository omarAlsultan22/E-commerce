import 'package:flutter/material.dart';


class BuildNavigatorPushReplacement {
  static void build({
    required Widget link,
    required BuildContext context,
  }) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => link
      ),
    );
  }
}