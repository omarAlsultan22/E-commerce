import 'package:flutter/material.dart';


class PaymentFieldLayout extends StatelessWidget {
  final String iconName;
  final IconData iconType;
  final VoidCallback onTap;

  const PaymentFieldLayout({
    required this.iconName,
    required this.iconType,
    required this.onTap,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        height: 200.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconType, size: 50.0),
              Text(iconName)
            ],
          ),
        ),
      ),
    );
  }
}