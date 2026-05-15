import 'exception_mapper.dart';
import '../exceptions/unknown_exception.dart';
import '../exceptions/base/app_exception.dart';


class ErrorHandler {
  final dynamic error;
  final StackTrace stackTrace;
  late final ExceptionMapper _exceptionMapper;

  ErrorHandler({
    required this.error,
    required this.stackTrace
  }) {
    _exceptionMapper = ExceptionMapper(error: error);
  }

  // ==================== Main Function ====================

  AppException handleException() {
    // Log the error (for analytics)
    _logError(error, stackTrace);

    final exceptionFromType = _mapByType(error);

    if (exceptionFromType != null) {
      return exceptionFromType;
    }

    final exceptionFromString = _mapByStringPattern(error);

    if (exceptionFromString != null) {
      return exceptionFromString;
    }

    if (_exceptionMapper.isSharedPrefsError()) {
      final exception = _mapByType(error);
      if (exception != null) {
        return exception;
      }
    }

    return AppUnknownException(message: error.toString());
  }

  // ==================== Helper Functions for Checking ====================

  AppException? _mapByType(dynamic error) {
    final isKeyFound = _exceptionMapper.isKey(error);
    if (isKeyFound) {
      final value = _exceptionMapper.mapByType();
      return value;
    }
    return null;
  }

  AppException? _mapByStringPattern(dynamic error) {
    for (var key in _exceptionMapper.keys) {
      if (error.toString().contains(key)) {
        final value = _exceptionMapper.mapByType();
        return value;
      }
    }
    return null;
  }

  void _logError(dynamic error, StackTrace? stackTrace) {
    // For tracking and analytics
    print('════════════════════════════════════════');
    print('❌ Error caught: ${error.runtimeType}');
    print('Message: $error');
    if (stackTrace != null) {
      print('StackTrace: $stackTrace');
    }
    print('════════════════════════════════════════');
  }
}
