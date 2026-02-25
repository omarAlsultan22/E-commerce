import 'app_exception.dart';


class ServerException extends AppException {
  final int? statusCode;

  const ServerException({
    super.message,
    super.isConnectionError,
    this.statusCode,
    super.stackTrace,
  });
}