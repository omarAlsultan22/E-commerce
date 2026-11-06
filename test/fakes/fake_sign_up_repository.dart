import 'package:firebase_auth/firebase_auth.dart';
import 'package:international_cuisine/core/data/models/user_model.dart';
import 'package:international_cuisine/features/auth/domain/repositories/sign_up_repository.dart';


class FakeSignUpRepository implements SignUpRepository {
  int createUserInfoCallCount = 0;
  UserModel? lastUserModel;
  UserCredential? lastUserCredential;
  Object? createUserInfoError;

  @override
  Future<void> createUserInfo({
    required UserModel userModel,
    required UserCredential userCredential,
  }) async {
    createUserInfoCallCount++;
    lastUserModel = userModel;
    lastUserCredential = userCredential;
    if (createUserInfoError != null) throw createUserInfoError!;
  }
}