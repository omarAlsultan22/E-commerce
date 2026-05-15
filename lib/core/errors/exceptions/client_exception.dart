import 'base/app_exception.dart';


class AppClientException extends AppException {
  AppClientException({
    super.statusCode,
    super.message,
    super.code
  });

  @override
  AppException getException() {
    return AppClientException(
        message: error.toString(),
        statusCode: statusCode
    );
  }
}