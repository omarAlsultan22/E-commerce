import 'base/app_exception.dart';


class AppSecurityException extends AppException {
  AppSecurityException({
    required super.message,
    super.statusCode,
    super.code
  });

  @override
  AppException getException() {
    // TODO: implement getException
    throw UnimplementedError();
  }
}