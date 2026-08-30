import '../exceptions/url_launcher_app_exceptions.dart';
import '../exceptions/unknown_app_exception.dart';
import '../exceptions/base/app_exception.dart';
import 'package:flutter/services.dart';
import 'exception_mapper.dart';


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

    return _mapByTypePattern() ??
        _mapByStringPattern() ??
        _mapByUrlLauncherError() ??
        UnknownAppException(message: error.toString());
  }

  // ==================== Helper Functions for Checking ====================

  bool _isUrlLauncherError() {
    final errorStr = error.toString().toLowerCase();
    return errorStr.contains('url_launcher') ||
        error is PlatformException && errorStr.contains('url') ||
        error is MissingPluginException && errorStr.contains('url');
  }

  AppException? _mapByTypePattern() {
    if (_exceptionMapper.isKey) {
      return _exceptionMapper.mapByTypePattern();
    }
    return null;
  }

  AppException? _mapByStringPattern() {
    for (var key in _exceptionMapper.keys) {
      if (error.toString().contains(key)) {
        return _exceptionMapper.mapByStringPattern();
      }
    }
    return null;
  }

  AppException? _mapByUrlLauncherError() {
    if (_isUrlLauncherError()) {
      final prefsException = UrlLauncherAppException(
        error: error,
        code: (error as PlatformException).code,
      );
      return prefsException.handle();
    }
    return null;
  }

  void _logError(dynamic error, StackTrace? stackTrace) {
    // For tracking and analytics
    print('════════════════════════════════════════');
    print('❌ Error caught: ${error.runtimeType}');
    print('Message: ${error.toString()}');
    if (stackTrace != null) {
      print('StackTrace: $stackTrace');
    }
    print('════════════════════════════════════════');
  }
}
