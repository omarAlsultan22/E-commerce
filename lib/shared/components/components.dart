import 'dart:async';
import 'package:flutter/material.dart';
import 'package:international_cuisine/shared/local/shared_preferences.dart';
import '../../modules/home/home_screen.dart';


SnackBar buildSnackBar(String message, Color backgroundColor) {
  return SnackBar(
    content: Text(message),
    backgroundColor: backgroundColor,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    duration: const Duration(seconds: 3),
  );
}


Future isLoggedIn(BuildContext context) async {
  CacheHelper.getString(key: 'IsLoggedIn').then((value) {
    if (value != null) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()));
      });
    }
  });
}


Timer? timer;
int timeLeft = 2;

void startTimer(BuildContext context) {
  timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (timeLeft > 0) {
      timeLeft--;
    } else {
      timer.cancel();
      isLoggedIn(context);
    }
  });
}


Widget sizedBox() =>
    const SizedBox(
      height: 30.0,
    );

String? validator(String value, String fieldName, {String? newPassword}) {
  if (value.isEmpty) {
    return 'يرجي أدخال $fieldName';
  }
  if (fieldName == 'email' && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return 'يرجي أدخال الايميل الصحيح';
  }
  if (fieldName == 'new password again' && value != newPassword) {
    return 'كلمتان المرور غير متطابقتان';
  }
  return null;
}

Widget buildInputField({
  required TextEditingController controller,
  required String hint,
  String? label,
  IconData? icon,
  TextInputType? keyboardType,
  bool obscureText = false,
  Widget? suffixIcon,
  String? Function(String?)? validator,

}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    obscureText: obscureText,
    cursorColor: Colors.amber,
    cursorRadius: const Radius.circular(100.0),
    validator: validator,
    decoration: InputDecoration(
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      labelText: label,
      labelStyle: const TextStyle(color: Colors.amber),
      prefixIcon: Icon(icon, color: Colors.amber),
      suffixIcon: suffixIcon,
    ),
    style: const TextStyle(color: Colors.white),
  );
}



