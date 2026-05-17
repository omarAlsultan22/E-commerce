import 'base/app_exception.dart';
import 'network_app_exception.dart';
import 'base/app_exception_convertible.dart';
import '../../domain/services/connectivity_service/connectivity_service.dart';


class FirebaseAppException extends AppException implements AppExceptionConvertible {
  FirebaseAppException({
    super.code,
    super.error,
    super.message
  });

  static final connectivityService = ConnectivityService();
  static const String _msgNoInternet = 'لا يوجد اتصال بالإنترنت';

  Map<String, AppException> map = {
    // Network
    'unavailable': NetworkAppException(
        message: _msgNoInternet, connectivityService: connectivityService),
    'network-error': NetworkAppException(
        message: _msgNoInternet, connectivityService: connectivityService),
    'network-request-failed': NetworkAppException(
        message: _msgNoInternet, connectivityService: connectivityService),

    // Firestore
    'permission-denied': FirestoreAppException(code: 'permission-denied',
        message: 'ليس لديك إذن للوصول'),
    'not-found': FirestoreAppException(
        code: 'not-found', message: 'لم يتم العثور على البيانات'),
    'already-exists': FirestoreAppException(
        code: 'already-exists', message: 'البيانات موجودة بالفعل'),
    'unauthenticated': FirestoreAppException(
        code: 'unauthenticated', message: 'المستخدم غير مصادق عليه'),
    'failed-precondition': FirestoreAppException(
        code: 'failed-precondition', message: 'فشل الشرط المسبق'),

    // Authentication
    'user-not-found': AuthAppException(
        code: 'user-not-found',
        message: 'لا يوجد مستخدم مسجل بهذا البريد الإلكتروني'),
    'invalid-email': AuthAppException(
        code: 'invalid-email', message: 'عنوان البريد الإلكتروني غير صالح'),
    'wrong-password': AuthAppException(
        code: 'wrong-password', message: 'كلمة المرور خاطئة'),
    'email-already-in-use': AuthAppException(
        code: 'email-already-in-use',
        message: 'البريد الإلكتروني مستخدم بالفعل'),
    'weak-password': AuthAppException(
        code: 'weak-password', message: 'كلمة المرور ضعيفة'),
    'user-disabled': AuthAppException(
        code: 'user-disabled', message: 'حساب المستخدم معطل'),
    'too-many-requests': AuthAppException(code: 'too-many-requests',
        message: 'محاولات كثيرة جداً، حاول مرة أخرى لاحقاً'),
    'invalid-credential': AuthAppException(
        code: 'invalid-credential', message: 'بيانات تسجيل الدخول غير صالحة'),
    'requires-recent-login': AuthAppException(
        code: 'requires-recent-login', message: 'يرجى تسجيل الدخول مرة أخرى'),

    // Storage
    'object-not-found': StorageAppException(
        code: 'object-not-found', message: 'الملف غير موجود في التخزين'),
    'retry-limit-exceeded': StorageAppException(code: 'retry-limit-exceeded',
        message: 'تم تجاوز حد إعادة المحاولة، يرجى المحاولة مرة أخرى لاحقاً'),
  };

  @override
  AppException getException() {
    final isKeyFound = map.containsKey(error.code);
    if (isKeyFound) {
      final value = map[error.code];
      if (value != null) {
        return value;
      }
    }
    return FirebaseAppException(error: 'خطأ في Firebase');
  }
}


class AuthAppException extends FirebaseAppException {
  AuthAppException({
    super.code,
    required super.message
  });
}


class FirestoreAppException extends FirebaseAppException {
  FirestoreAppException({
    super.code,
    required super.message
  });
}


class StorageAppException extends FirebaseAppException {
  StorageAppException({
    super.code,
    required super.message
  });
}