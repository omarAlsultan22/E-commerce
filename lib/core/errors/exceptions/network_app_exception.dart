import 'package:flutter/src/widgets/framework.dart';
import '../../domain/services/connectivity_service/connectivity_service.dart';
import 'package:international_cuisine/core/errors/exceptions/base/app_exception.dart';
import 'package:international_cuisine/core/presentation/widgets/internet_unavailability.dart';


class NetworkAppException extends AppException {
  final ConnectivityService? connectivityService;

  NetworkAppException({
    super.code,
    super.message,
    this.connectivityService
  });

  @override
  Widget buildErrorWidget({VoidCallback? onRetry}) {
    return InternetUnavailability(
        onRetry: onRetry,
        connectivityService: connectivityService
    );
  }
}