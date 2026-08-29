import 'base/app_exception.dart';
import 'base/exception_handler.dart';


class UrlLauncherAppException extends AppException implements ExceptionHandler {
  UrlLauncherAppException({
    super.code,
    super.error,
    super.message
  });

  static const String _msgSysError = 'System error occurred';

  static final Map<String, AppException> _urlLauncherExceptionPatterns = {
    'cannotopenurl': CantLaunchUrlAppException(
        message: 'No application available to open this link'),
    'activitynotfound': PlatformUrlAppException(message: _msgSysError),
    'platformexception': PlatformUrlAppException(message: _msgSysError),
  };

  @override
  bool canHandle() {
    final errorStr = error.toString().toLowerCase();
    return _urlLauncherExceptionPatterns.containsKey(errorStr);
  }

  @override
  AppException? handle() {
    if(canHandle()) {
      final errorStr = error.toString().toLowerCase();
      return _urlLauncherExceptionPatterns[errorStr];
    }
    return UrlLauncherAppException(
        code: code,
        message: 'Failed to open link'
    );
  }
}


class CantLaunchUrlAppException extends UrlLauncherAppException{
  CantLaunchUrlAppException({required super.message});
}

class PlatformUrlAppException extends UrlLauncherAppException {
  PlatformUrlAppException({required super.message});
}



