import 'back_button_widget.dart';
import 'package:flutter/material.dart';


class AppbarWidget {
  static PreferredSizeWidget build(BuildContext context) {
    return AppBar(
        leading: BackButtonWidget(onPressed: () => Navigator.pop(context)
        )
    );
  }
}
