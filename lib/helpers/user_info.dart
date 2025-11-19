import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:international_cuisine/modles/user_model.dart';


class UserInfoConverter {
  final UserModel userModel;

  UserInfoConverter({required this.userModel});

  factory UserInfoConverter.fromDocumentSnapshot(DocumentSnapshot snapshot, String location) {
    if (!snapshot.exists || snapshot.data() == null) {
      throw Exception('User document does not exist or is empty');
    }
    if(location.isEmpty) {
      throw Exception('User location is empty');
    }

    final modelMap = snapshot.data()! as Map<String, dynamic>;
    modelMap['location'] = location;
    return UserInfoConverter(
      userModel: UserModel.fromJson(modelMap),
    );
  }
}