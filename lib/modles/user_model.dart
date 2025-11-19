import 'json_model.dart';


class UserModel implements JsonModel{
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

  @override
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
    };
  }
}

