import 'dart:ui';
import '../../constants/app_colors.dart';
import '../../errors/exceptions/base/app_exception.dart';


class MessageResult {
  final String? error;
  final bool isLoading;
  final String? message;
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
    required AppException error,
  }){
    return MessageResult(
        color: AppColors.errorRed,
        message: 'فشل التحديث: ${error.message}'
    );
  }
}