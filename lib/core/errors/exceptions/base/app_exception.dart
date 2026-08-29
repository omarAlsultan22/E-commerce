import 'package:flutter/cupertino.dart';
import '../../../presentation/widgets/states/error_state_widget.dart';


abstract class AppException implements Exception {
  final int? statusCode;
  final String? message;
  final dynamic error;
  final String? code;

  const AppException({
    this.statusCode,
    this.message,
    this.error,
    this.code,
  });

  @override
  String toString() {
    return error.message;
  }

  Widget buildErrorWidget({
    PreferredSizeWidget? appBar,
    required VoidCallback onRetry,
  }) {
    return ErrorStateWidget(
        appBar: appBar,
        error: message,
        onRetry: onRetry
    );
  }
}