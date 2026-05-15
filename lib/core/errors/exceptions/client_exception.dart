import 'base/app_exception.dart';


class ClientAppException extends AppException {
  ClientAppException({
    super.statusCode,
    super.message,
    super.code
  });
}