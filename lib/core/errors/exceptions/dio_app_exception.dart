import 'package:dio/dio.dart';
import 'client_exception.dart';
import 'base/app_exception.dart';
import 'network_app_exception.dart';
import 'base/app_exception_convertible.dart';
import 'package:international_cuisine/core/constants/app_strings.dart';
import 'package:international_cuisine/core/errors/exceptions/server_app_exception.dart';
import 'package:international_cuisine/core/errors/exceptions/unknown_app_exception.dart';
import 'package:international_cuisine/core/errors/exceptions/security_app_exception.dart';


class DioAppException extends AppException implements AppExceptionConvertible {
  DioAppException({
    super.error,
    super.message
  });

  static const String _invalidDataCode = 'BAD_REQUEST';
  static const String _invalidDataMessage = 'بيانات غير صالحة';

  static const String _notFoundCode = 'NOT_FOUND';
  static const String _notFoundMessage = 'البيانات غير موجودة';

  static const String _conflictCode = 'CONFLICT';
  static const String _conflictMessage = 'تضارب في البيانات';

  static const String _serverErrorCode = 'SERVER_ERROR';
  static const String _serverErrorMessage = 'خطأ في الخادم، يرجى المحاولة مرة أخرى لاحقاً';

  static const String _dioError = 'DIO_ERROR';
  static const _noInternetMessage = AppStrings.noInternetMessage;
  static const String _networkTimeoutMessageSuffix = ' أو انتهت مهلة الاتصال';

  static const String _forbiddenCode = 'FORBIDDEN';
  static const String _unauthorizedCode = 'UNAUTHORIZED';
  static const String _unauthorizedMessage = 'يرجى تسجيل الدخول مرة أخرى';
  static const String _forbiddenMessage = 'ليس لديك صلاحية للوصول';

  static final Map<DioExceptionType, String> _dioErrorCodePatterns = {
    DioExceptionType.connectionTimeout: 'CONNECTION_TIMEOUT',
    DioExceptionType.sendTimeout: 'SEND_TIMEOUT',
    DioExceptionType.receiveTimeout: 'RECEIVE_TIMEOUT',
    DioExceptionType.connectionError: 'CONNECTION_ERROR',
  };

  static final Map<int, AppException Function(int?)> _badResponsePatterns = {
    400: (statusCode) =>
        ClientAppException(
          message: _invalidDataMessage,
          code: _invalidDataCode,
          statusCode: statusCode,
        ),
    422: (statusCode) =>
        ClientAppException(
          message: _invalidDataMessage,
          code: _invalidDataCode,
          statusCode: statusCode,
        ),

    401: (statusCode) =>
        SecurityAppException(
          message: statusCode == 401
              ? _unauthorizedMessage
              : _forbiddenMessage,
          code: statusCode == 401 ? _unauthorizedCode : _forbiddenCode,
          statusCode: statusCode,
        ),
    403: (statusCode) =>
        SecurityAppException(
          message: statusCode == 401
              ? _unauthorizedMessage
              : _forbiddenMessage,
          code: statusCode == 401 ? _unauthorizedCode : _forbiddenCode,
          statusCode: statusCode,
        ),

    404: (statusCode) =>
        ClientAppException(
          message: _notFoundMessage,
          code: _notFoundCode,
          statusCode: statusCode,
        ),
    410: (statusCode) =>
        ClientAppException(
          message: _notFoundMessage,
          code: _notFoundCode,
          statusCode: statusCode,
        ),

    409: (statusCode) =>
        ClientAppException(
          message: _conflictMessage,
          code: _conflictCode,
          statusCode: statusCode,
        ),
    412: (statusCode) =>
        ClientAppException(
          message: _conflictMessage,
          code: _conflictCode,
          statusCode: statusCode,
        ),

    429: (statusCode) =>
        ClientAppException(
          message: 'تم تجاوز حد الطلبات، يرجى المحاولة مرة أخرى لاحقاً',
          code: 'TOO_MANY_REQUESTS',
          statusCode: statusCode,
        ),

    500: (statusCode) =>
        ServerAppException(
          message: _serverErrorMessage,
          code: _serverErrorCode,
          statusCode: statusCode,
        ),
    502: (statusCode) =>
        ServerAppException(
          message: _serverErrorMessage,
          code: _serverErrorCode,
          statusCode: statusCode,
        ),
    503: (statusCode) =>
        ServerAppException(
          message: _serverErrorMessage,
          code: _serverErrorCode,
          statusCode: statusCode,
        ),
    504: (statusCode) =>
        ServerAppException(
          message: _serverErrorMessage,
          code: _serverErrorCode,
          statusCode: statusCode,
        ),
  };


  static final Map<DioExceptionType,
      AppException Function(DioException)> _dioTypeExceptionHandlers = {
    DioExceptionType.connectionTimeout: (error) =>
        NetworkAppException(
          message: '$_noInternetMessage$_networkTimeoutMessageSuffix',
          code: _dioErrorCodePatterns[error.type] ?? _dioError,
        ),
    DioExceptionType.sendTimeout: (error) =>
        NetworkAppException(
          message: '$_noInternetMessage$_networkTimeoutMessageSuffix',
          code: _dioErrorCodePatterns[error.type] ?? _dioError,
        ),
    DioExceptionType.receiveTimeout: (error) =>
        NetworkAppException(
          message: '$_noInternetMessage$_networkTimeoutMessageSuffix',
          code: _dioErrorCodePatterns[error.type] ?? _dioError,
        ),
    DioExceptionType.connectionError: (error) =>
        NetworkAppException(
          message: '$_noInternetMessage$_networkTimeoutMessageSuffix',
          code: _dioErrorCodePatterns[error.type] ?? _dioError,
        ),
    DioExceptionType.badCertificate: (error) =>
        SecurityAppException(
          message: 'شهادة أمان غير صالحة',
          code: 'BAD_CERTIFICATE',
        ),
    DioExceptionType.badResponse: (error) {
      final statusCode = error.response?.statusCode;
      final handler = _badResponsePatterns[statusCode];
      return handler != null
          ? handler(statusCode)
          : ServerAppException(
        message: 'خطأ في الخادم: $statusCode',
        statusCode: statusCode,
      );
    },
    DioExceptionType.cancel: (error) =>
        ClientAppException(
          message: 'تم إلغاء الطلب',
          code: 'REQUEST_CANCELLED',
        ),
    DioExceptionType.unknown: (error) =>
        UnknownAppException(
          message: error.message ?? 'حدث خطأ غير متوقع',
          code: 'UNKNOWN_DIO_ERROR',
        )
  };

  @override
  AppException getException() {
    final e = error as DioException;
    return _dioTypeExceptionHandlers[e.type]!(error);
  }
}