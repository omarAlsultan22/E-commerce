import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';


class BackButtonWidget extends StatelessWidget {
  final Color? color;
  final VoidCallback? onPressed;

  const BackButtonWidget({
    super.key,
    this.color,
    required this.onPressed
  });

  static const _splashRadius = 12.0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return IconButton(
      icon: Icon(CupertinoIcons.arrowshape_turn_up_right_fill,
          color: color ?? AppColors.black
      ),
      onPressed: onPressed,
      splashRadius: _splashRadius,
    );
  }
}