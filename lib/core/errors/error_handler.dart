import 'exceptions/server_exception.dart';
import 'exceptions/app_exception.dart';


class ErrorHandler {
  static AppException handleException(AppException exception) {
    return ServerException(
        message: exception.message);
  }
}
