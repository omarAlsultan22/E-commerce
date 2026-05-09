import 'base/app_exception.dart';


class ServerException extends AppException{
  ServerException({
    super.code,
    required super.message,
    required super.statusCode
  });
}