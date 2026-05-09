import 'package:flutter/cupertino.dart';
import '../../../presentation/widgets/states/error_state_widget.dart';


abstract class AppException implements Exception {
  final int? statusCode;
  final String? message;
  final String? code;

  const AppException({
    this.message,
    this.statusCode,
    this.code,
  });

  Widget buildErrorWidget({VoidCallback? onRetry}) {
    return ErrorStateWidget(
        error: message,
        onRetry: onRetry
    );
  }
}