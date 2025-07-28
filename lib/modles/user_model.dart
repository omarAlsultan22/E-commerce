import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String firstName;
  final String lastName;
  final String phone;
  final String? location;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.location,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json['firstName']?.toString() ?? 'غير معروف',
      lastName: json['lastName']?.toString() ?? '',
      phone: json['phone']?.toString() ?? 'غير معروف',
      location: json['location']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
    };
  }
}

class UserInfo {
  final UserModel userModel;

  UserInfo({required this.userModel});

  factory UserInfo.fromDocumentSnapshot(DocumentSnapshot snapshot, String location) {
    if (!snapshot.exists || snapshot.data() == null) {
      throw Exception('User document does not exist or is empty');
    }
    if(location.isEmpty) {
      throw Exception('User location is empty');
    }

    final modelMap = snapshot.data()! as Map<String, dynamic>;
    modelMap['location'] = location;
    return UserInfo(
      userModel: UserModel.fromJson(modelMap),
    );
  }
}