import 'base/app_exception.dart';


class ServerAppException extends AppException{
  ServerAppException({
    super.code,
    required super.message,
    required super.statusCode
  });
}