import 'package:international_cuisine/core/errors/exceptions/base/app_exception.dart';


class UnknownAppException extends AppException{
  UnknownAppException({
    super.code,
    required super.message
  });
}