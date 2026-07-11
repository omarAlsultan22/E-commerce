import 'package:flutter/material.dart';
import 'navigator_push_replacement.dart';


class BuildNavigatorWithDelay {
  static void build({
    required Widget link,
    required BuildContext context,
  }) {
    Future.delayed(const Duration(seconds: 2), () {
      BuildNavigatorPushReplacement.build(link: link, context: context);
    });
  }
}



