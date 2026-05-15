import 'network_exception.dart';
import 'base/app_exception.dart';
import 'base/app_exception_convertible.dart';
import '../../domain/services/connectivity_service/connectivity_service.dart';


class AppFirebaseException extends AppException implements AppExceptionConvertible{
  AppFirebaseException({
    super.error,
    super.message
  });

  static final connectivityService = ConnectivityService();
  static const String _msgNoInternet = 'لا يوجد اتصال بالإنترنت';

  Map<String, AppException> map = {
    'unavailable': AppNetworkException(
        message: _msgNoInternet,
        connectivityService: connectivityService),
    'network-error': AppNetworkException(
        message: _msgNoInternet,
        connectivityService: connectivityService),
    'network-request-failed': AppNetworkException(
        message: _msgNoInternet,
        connectivityService: connectivityService),
    'permission-denied': AppFirebaseException(
        message: 'ليس لديك إذن للوصول'),
    'not-found': AppFirebaseException(message: 'لم يتم العثور على البيانات'),
    'already-exists': AppFirebaseException(message: 'البيانات موجودة بالفعل'),
    'user-not-found': AppFirebaseException(
        message: 'لا يوجد مستخدم مسجل بهذا البريد الإلكتروني'),
    'invalid-email': AppFirebaseException(message: 'عنوان البريد الإلكتروني غير صالح'),
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
    return AppFirebaseException(error: 'خطأ في Firebase');
  }
}