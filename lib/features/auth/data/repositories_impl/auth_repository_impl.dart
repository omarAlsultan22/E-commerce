import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/domain/data_sources/remote/auth_service.dart';
import 'package:international_cuisine/core/constants/app_durations.dart';


class AuthRepositoryImpl implements AuthRepository {
  final AuthService _service;

  AuthRepositoryImpl({
    required AuthService service,
    FlutterSecureStorage? storage
  })
      : _service = service;

  @override
  Future<UserCredential> signIn({
    required String userEmail,
    required String userPassword
  }) async {
    return await _service.signIn(
      email: userEmail,
      password: userPassword,
    ).then((value) {
      return value;
    });
  }

  @override
  Future<UserCredential> signUp({
    required String userEmail,
    required String userPassword
  }) async {
    return await _service.signUp(
      email: userEmail,
      password: userPassword,
    );
  }

  @override
  Future<User?> updateProfile({
    required String newEmail,
    required String currentPassword,
    required String newPassword
  }) async {
    final user = await _service.updateProfile(
        newEmail: newEmail,
        currentPassword: currentPassword,
        newPassword: newPassword
    );
    if (user != null) {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential).timeout(
          AppDurations.seconds);
      await user.verifyBeforeUpdateEmail(newEmail).timeout(
          AppDurations.seconds).then((_) {
        user.updatePassword(newPassword).timeout(AppDurations.seconds);
      });
    }
    return null;
  }

  @override
  Future<void> sendResetEmail({required String userEmail}) async {
    await _service.sendResetEmail(userEmail: userEmail);
  }

  @override
  Future<void> signOut() async {
    await _service.signOut();
  }
}