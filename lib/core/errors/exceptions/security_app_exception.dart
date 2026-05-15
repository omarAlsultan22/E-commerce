import 'base/app_exception.dart';


class SecurityAppException extends AppException {
  SecurityAppException({
    required super.message,
    super.statusCode,
    super.code
  });
}