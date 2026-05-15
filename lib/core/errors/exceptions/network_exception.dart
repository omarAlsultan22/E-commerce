import 'package:flutter/src/widgets/framework.dart';
import '../../domain/services/connectivity_service/connectivity_service.dart';
import 'package:international_cuisine/core/errors/exceptions/base/app_exception.dart';
import 'package:international_cuisine/core/presentation/widgets/internet_unavailability.dart';


class AppNetworkException extends AppException {
  final ConnectivityService? connectivityService;

  AppNetworkException({
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

  @override
  AppException getException() {
    // TODO: implement getException
    throw UnimplementedError();
  }
}