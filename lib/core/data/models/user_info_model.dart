import 'base/json_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class UserInfoModel implements JsonModel {
  final String firstName;
  final String lastName;
  final String? fullName;
  final String userPhone;
  final String? userLocation;

  UserInfoModel({
    this.fullName,
    this.userLocation,
    required this.firstName,
    required this.lastName,
    required this.userPhone,
  });

  factory UserInfoModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserInfoModel(
      firstName: data['firstName']?.toString() ?? '',
      lastName: data['lastName']?.toString() ?? '',
      fullName: data['fullName']?.toString() ?? '',
      userPhone: data['userPhone']?.toString() ?? '',
      userLocation: data['userLocation']?.toString() ?? '',
    );
  }

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      userPhone: json['userPhone']?.toString() ?? '',
      userLocation: json['userLocation']?.toString() ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'userPhone': userPhone,
      'userLocation': userLocation,
      'fullName': '${firstName.trim()} ${lastName.trim()}',
      'createdAt': FieldValue.serverTimestamp()
    };
  }
}

