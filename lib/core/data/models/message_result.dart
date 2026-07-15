import 'dart:ui';
import '../../constants/app_colors.dart';
import '../../errors/exceptions/base/app_exception.dart';


class MessageResult {
  final AppException? error;
  final String? message;
  final bool isLoading;
  final Color? color;

  MessageResult({
    this.isLoading = false,
    this.message,
    this.error,
    this.color
  });

  factory MessageResult.initial(){
    return MessageResult();
  }

  factory MessageResult.loading(){
    return MessageResult(
        isLoading: true
    );
  }

  factory MessageResult.success({String? message}){
    return MessageResult(
        color: AppColors.successGreen,
        message: message ?? 'تم التحديث بنجاح'
    );
  }

  factory MessageResult.error({
    String? message,
    required AppException error,
  }){
    final ms = message ?? 'فشل التحديث: ';
    return MessageResult(
        error: error,
        color: AppColors.errorRed,
        message: '$ms${error.message}'
    );
  }
}