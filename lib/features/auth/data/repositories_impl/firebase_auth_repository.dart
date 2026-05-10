import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:international_cuisine/core/constants/app_durations.dart';
import 'package:international_cuisine/core/data/data_sources/remote/firebase_auth.dart';


class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuthService _authService;

  FirebaseAuthRepository({
    required FirebaseAuthService authService,
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
    try {
      return await _authService.signUp(
        email: email,
        password: password,
      );
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<void> updateProfile({
    required String newEmail,
    required String currentPassword,
    required String newPassword
  }) async {
    try {
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
    catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> sendResetEmail({required String userEmail}) async {
    _authService.sendResetEmail(userEmail: userEmail);
  }

  @override
  Future<void> signOut() async {
    _authService.signOut();
  }
}