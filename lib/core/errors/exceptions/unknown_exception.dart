import 'package:international_cuisine/core/errors/exceptions/base/app_exception.dart';


class AppUnknownException extends AppException{
  AppUnknownException({required super.message});

  @override
  AppException getException() {
    // TODO: implement getException
    throw UnimplementedError();
  }
}