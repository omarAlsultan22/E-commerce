import '../repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/data/models/user_info_model.dart';
import '../../../user_info/domain/repositories/user_info_repository.dart';
import '../../../../core/data/data_sources/local/shared_preferences.dart';


class AuthUseCase {
  final AuthRepository _authRepository;
  final UserInfoRepository? _userInfoRepository;

  AuthUseCase({
    required AuthRepository authRepository,
    UserInfoRepository? userInfoRepository
  })
      :
        _authRepository = authRepository,
        _userInfoRepository = userInfoRepository!;


  Future<void> signInExecute({
    required String userEmail,
    required String userPassword,
  }) async {
    try {
      final userCredential = await _authRepository.signIn(
          userEmail: userEmail,
          userPassword: userPassword
      );
      CacheHelper.setStringValue(key: 'uId', value: userCredential.user!.uid);
    } catch (e) {
      rethrow;
    }
  }


  Future<void> signUpExecute({
    required String firstName,
    required String lastName,
    required String userEmail,
    required String userPassword,
    required String userPhone,
    required String userLocation,
  }) async {
    try {
      final userCredential = await _authRepository.signUp(
        email: userEmail,
        password: userPassword,
      );

      UserInfoModel userModel = UserInfoModel(
        firstName: firstName,
        lastName: lastName,
        userPhone: userPhone,
        userLocation: userLocation
      );

      await _userInfoRepository!.setInfo(
          userModel: userModel, userCredential: userCredential
      );

    } catch (e) {
      rethrow;
    }
  }


  Future<void> updateProfileExecute({
    required String newEmail,
    required String newPassword,
    required String currentPassword
  }) async {
    final user = await _authRepository.updateProfile(
        newEmail: newEmail,
        newPassword: newPassword,
        currentPassword: currentPassword
    );
    if (user != null) {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      try {
        await user.reauthenticateWithCredential(credential);
        await user.verifyBeforeUpdateEmail(newEmail).then((_) {
          user.updatePassword(newPassword).then((_) {});
        });
      } catch (e) {
        rethrow;
      }
    }
  }


  Future<void> signOutExecute() async {
    try {
      await _authRepository.signOut();
    } catch (e) {
      rethrow;
    }
  }
}

