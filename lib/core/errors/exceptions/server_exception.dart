import 'app_exception.dart';


class ServerException extends AppException {
  final int? statusCode;

  const ServerException({
    this.statusCode,
    super.stackTrace,
    required super.message,
  });
}