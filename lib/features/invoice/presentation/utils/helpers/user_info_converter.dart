import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../core/data/models/user_info_model.dart';


class UserInfoConverter {
  final UserInfoModel userModel;

  UserInfoConverter({required this.userModel});

  factory UserInfoConverter.fromDocumentSnapshot(DocumentSnapshot doc,
      String Location) {
    if (!doc.exists || doc.data() == null) {
      throw Exception('User document does not exist or is empty');
    }
    final modelMap = doc.data()! as Map<String, dynamic>;

    if (Location.isEmpty) {
      return UserInfoConverter(
        userModel: UserInfoModel.fromJson(modelMap),
      );
    }

    modelMap['location'] = Location;
    return UserInfoConverter(
      userModel: UserInfoModel.fromJson(modelMap),
    );
  }
}