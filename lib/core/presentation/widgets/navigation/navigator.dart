import 'package:flutter/material.dart';
import 'package:international_cuisine/features/auth/presentation/screens/sgin_in_screen.dart';


void navigator({
  Widget? link,
  required BuildContext context,
}) {
  Future.delayed(const Duration(seconds: 1), () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => link ?? const SignInScreen()
      ),
    );
  });
}