import 'base/app_exception.dart';
import 'network_app_exception.dart';
import 'base/app_exception_convertible.dart';
import '../../domain/services/connectivity_service/connectivity_service.dart';


class FirebaseAppException extends AppException implements AppExceptionConvertible{
  FirebaseAppException({
    super.error,
    super.message
  });

  static final connectivityService = ConnectivityService();
  static const String _msgNoInternet = 'لا يوجد اتصال بالإنترنت';

  Map<String, AppException> map = {
    'unavailable': NetworkAppException(
        message: _msgNoInternet,
        connectivityService: connectivityService),
    'network-error': NetworkAppException(
        message: _msgNoInternet,
        connectivityService: connectivityService),
    'network-request-failed': NetworkAppException(
        message: _msgNoInternet,
        connectivityService: connectivityService),
    'permission-denied': FirebaseAppException(
        message: 'ليس لديك إذن للوصول'),
    'not-found': FirebaseAppException(message: 'لم يتم العثور على البيانات'),
    'already-exists': FirebaseAppException(message: 'البيانات موجودة بالفعل'),
    'user-not-found': FirebaseAppException(
        message: 'لا يوجد مستخدم مسجل بهذا البريد الإلكتروني'),
    'invalid-email': FirebaseAppException(message: 'عنوان البريد الإلكتروني غير صالح'),
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