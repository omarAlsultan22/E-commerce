import 'base/app_exception.dart';


class SecurityAppException extends AppException {
  SecurityAppException({
    super.code,
    super.statusCode,
    required super.message
  });
}