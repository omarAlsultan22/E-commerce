import 'base/app_exception.dart';


class ValidationException extends AppException {
  ValidationException({super.message = 'Fields cannot be empty.'});
}