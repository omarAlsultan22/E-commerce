import 'package:flutter/material.dart';


class ActionButtonWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final double verticalPadding;
  final double horizontalPadding;

  const ActionButtonWidget({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
    this.verticalPadding = 12.0,
    this.horizontalPadding = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
      ),
      onPressed: onPressed,
    );
  }
}