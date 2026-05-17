import '../base/app_exception.dart';
import 'base/cache_app_exceptions.dart';
import '../base/exception_handler.dart';


class SharedPrefsAppException extends CacheAppException implements ExceptionHandler {
  SharedPrefsAppException({
    super.code,
    super.error,
    super.message,
    super.operation,
  });

  static const String _msgConnectionIssue = 'مشكلة في الاتصال بنظام التخزين';
  static const String _msgCorruptedFile = 'ملف التخزين المحلي تالف، ستتم إعادة تهيئته';

  static final Map<String, AppException> _errorFactories = {
    'streamcorrupted': SharedPrefsInitException(
      message: _msgCorruptedFile,
      platformCode: 'STREAM_CORRUPTED',
    ),
    'invalid stream header': SharedPrefsInitException(
      message: _msgCorruptedFile,
      platformCode: 'INVALID_STREAM_HEADER',
    ),
    'channel-error': SharedPrefsPlatformException(
      message: _msgConnectionIssue,
      platformCode: 'CHANNEL_ERROR',
    ),
    'unable to establish connection': SharedPrefsPlatformException(
      message: _msgConnectionIssue,
      platformCode: 'CONNECTION_FAILED',
    ),
  };

  @override
  bool canHandle() {
    return _errorFactories.containsKey(error);
  }

  @override
  AppException? handle() {
    if (canHandle()) {
      final exception = _errorFactories[error];
      if (exception != null) {
        return exception;
      }
    }
    return SharedPrefsPlatformException(
      message: error.message ?? 'خطأ في منصة التخزين المحلية',
      platformCode: code,
    );
  }
}


class SharedPrefsInitException extends SharedPrefsAppException {
  final String? platformCode;

  SharedPrefsInitException({
    super.message,
    this.platformCode,
    super.code = 'SHARED_PREFS_INIT_ERROR',
  });
}


class SharedPrefsPlatformException extends SharedPrefsAppException {
  final String? platformCode;

  SharedPrefsPlatformException({
    super.message,
    this.platformCode,
    super.code = 'SHARED_PREFS_PLATFORM_ERROR',
  });
}


class SharedPrefsOperationException extends SharedPrefsAppException {
  final String? key;

  SharedPrefsOperationException({
    required super.message,
    this.key,
    super.operation,
    super.code = 'SHARED_PREFS_OPERATION_ERROR',
  });
}


class SharedPrefsCastException extends SharedPrefsAppException {
  final String? key;
  final String? expectedType;

  SharedPrefsCastException({
    super.message,
    this.key,
    this.expectedType,
    super.code = 'SHARED_PREFS_CAST_ERROR',
  });
}