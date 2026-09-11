import 'package:flutter/material.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';


class LoadingWidget extends StatelessWidget {
  final double? spacing;
  final double? strokeWidth;
  final Color? color;

  const LoadingWidget({
    super.key,
    this.spacing,
    this.strokeWidth,
    this.color,
  });

  static const _spacing = 24.0;
  static const _strokeWidth = 3.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: spacing ?? _spacing,
      width: spacing ?? _spacing,
      child: CircularProgressIndicator(
        color: color ?? AppColors.black,
        strokeWidth: strokeWidth ?? _strokeWidth,
      ),
    );
  }
}