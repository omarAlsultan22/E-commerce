import 'package:flutter/material.dart';


class BuildNavigatorPush {
  static void build({
    required Widget link,
    required BuildContext context,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => link
      ),
    );
  }
}