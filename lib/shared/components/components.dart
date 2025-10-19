import 'dart:async';
import 'package:flutter/material.dart';
import '../../modules/home/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:international_cuisine/modles/data_model.dart';
import 'package:international_cuisine/shared/local/shared_preferences.dart';


Future<List<DataModel>> getCountriesData({
  required DocumentSnapshot? lastDocument,
  required String collectionId,
  required void Function(DocumentSnapshot) updateLastDoc
}) async {
  final firebase = FirebaseFirestore.instance;
  Query query = firebase.collection('countriesData').doc(
      'L8nSAa05FTdy6I47cOaf')
      .collection(collectionId);

  if (lastDocument != null) {
    query = query.startAfterDocument(lastDocument);
  }

  final data = await query.limit(5).get();

  if (data.docs.isEmpty) {
    return [];
  }
  updateLastDoc(data.docs.last);
  DataList dataList = DataList.fromQuerySnapshot(data);
  return dataList.data;
}



Future<List<DataModel>> fetchPartialMatch({
  required String query,
  required String collectionId,
}) async {
  final firebase = FirebaseFirestore.instance;
  query = query.toLowerCase();

  final usersSnapshot = await firebase
      .collection('countriesData').doc('L8nSAa05FTdy6I47cOaf').collection(collectionId)
      .where('orderName', isGreaterThanOrEqualTo: query)
      .where('orderName', isLessThanOrEqualTo: '$query\uf8ff')
      .get();

  final results = await Future.wait(usersSnapshot.docs.map((userDoc) async {
    final dataModel = userDoc.data();
    final fullName = dataModel['orderName']?.toString().toLowerCase() ?? '';
    return fullName.contains(query)
        ? DataModel.fromJson(dataModel)
        : null;
  }));
  return results.whereType<DataModel>().toList();
}



Future<void> updateDataModel({
  required String collectionId,
  required String index,
  required int rating

}) async {
  final firebase = FirebaseFirestore.instance;
  await firebase.collection('countriesData').doc('L8nSAa05FTdy6I47cOaf')
      .collection(collectionId).doc(index).update({'rating': rating});
}



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



Future navigator({
  required Widget link,
  required BuildContext context,
}) async =>
  Navigator.push(context, MaterialPageRoute(builder: (context) => link));



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



