import 'base/app_exception.dart';


class ClientAppException extends AppException {
  ClientAppException({
    super.code,
    super.message,
    super.statusCode
  });
}