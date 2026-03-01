import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../widgets/internet_unavailability.dart';
import '../../domain/services/connectivity_service/connectivity_provider.dart';


class ConnectivityAwareService extends StatelessWidget {
  final Widget child;

  const ConnectivityAwareService({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivityService, _child) {
        if (!connectivityService.isConnected) {
          return InternetUnavailability(
              onRetry: () => Navigator.pop(context));
        }
        return child;
      },
    );
  }
}