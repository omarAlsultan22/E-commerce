import 'package:firebase_auth/firebase_auth.dart';


abstract class AuthErrorHandler {
  static String handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'كلمة المرور ضعيفة جدًا';
      case 'email-already-in-use':
        return 'البريد الإلكتروني مستخدم بالفعل';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صالح';
      default:
        return 'حدث خطأ أثناء التسجيل';
    }
  }
}