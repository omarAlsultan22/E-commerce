import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth;

  FirebaseAuthRepository({
    required FirebaseAuth auth,
    FlutterSecureStorage? storage
  })
      : _auth = auth;

  @override
  Future<UserCredential> signIn({
    required String userEmail,
    required String userPassword
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: userEmail,
      password: userPassword,
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
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw e;
    }
  }


  @override
  Future<User?> updateProfile({
    required String newEmail,
    required String currentPassword,
    required String newPassword
  }) async {
    final user = _auth.currentUser;
    return user;
  }


  @override
  Future<void> signOut() async {
    _auth.signOut();
  }
}