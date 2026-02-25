import 'app_exception.dart';


class NetworkException extends AppException {
  const NetworkException({super.message, super.isConnectionError, super.stackTrace});
}