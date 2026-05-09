import 'base/app_exception.dart';


class SecurityException extends AppException {
  SecurityException({
    required super.message,
    super.statusCode,
    super.code
  });
}