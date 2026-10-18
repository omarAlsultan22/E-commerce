import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/domain/data_sources/remote/auth_service.dart';
import 'package:international_cuisine/core/constants/app_durations.dart';


class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;

  AuthRepositoryImpl({
    required AuthService authService,
    FlutterSecureStorage? storage
  })
      : _authService = authService;

  @override
  Future<UserCredential> signIn({
    required String email,
    required String password
  }) async {
    return await _authService.signIn(
      email: email,
      password: password,
    ).then((value) {
      return value;
    });
  }

  @override
  Future<UserCredential> signUp({
    required String email,
    required String password
  }) async {
    return await _authService.signUp(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> updateProfile({
    required String newEmail,
    required String currentPassword,
    required String newPassword
  }) async {
    final user = await _authService.updateProfile(
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
  }

  @override
  Future<void> sendResetEmail({required String userEmail}) async {
    await _authService.sendResetEmail(userEmail: userEmail);
  }

  @override
  Future<void> signOut() async {
    await _authService.signOut();
  }
}