import 'package:firebase_auth/firebase_auth.dart';
import 'package:international_cuisine/core/constants/app_durations.dart';


class FirebaseAuthService {
  static final _firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
    ).timeout(AppDurations.seconds);
  }

  Future<UserCredential> signUp({
    required String email,
    required String password
  }) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password
    ).timeout(AppDurations.seconds);
  }

  Future<User?> updateProfile({
    required String newEmail,
    required String currentPassword,
    required String newPassword
  }) async {
    final user = _firebaseAuth.currentUser;
    return user;
  }

  Future<void> sendResetEmail({
    required String userEmail,
  }) async {
    await _firebaseAuth.sendPasswordResetEmail(email: userEmail);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut().timeout(AppDurations.seconds);
  }
}