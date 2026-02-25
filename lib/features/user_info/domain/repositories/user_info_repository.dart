import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/data/models/user_info_model.dart';
import 'package:international_cuisine/core/data/repositories_impl/base_user_repository.dart';


abstract class UserInfoRepository implements BaseUserRepository{
  Future<void> setInfo({
    required UserInfoModel userModel,
    required UserCredential userCredential
  });

  Future<void> updateInfo({
    required String firstName,
    required String lastName,
    required String userPhone,
    required String userLocation
  });
}