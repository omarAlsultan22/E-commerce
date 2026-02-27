import 'package:international_cuisine/features/home/presentation/states/home_data_state.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_provider.dart';
import '../../../../core/presentation/screens/internet_unavailability_screen.dart';
import '../../../../core/presentation/widgets/states/error_state_widget.dart';
import '../widgets/lists/list_home_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/home_data_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'intro_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
        builder: (context, connectivityProvider, childWidget) {
          if (!connectivityProvider.isConnected) {
            return InternetUnavailabilityScreen(
                onRetry: () => Navigator.pop(context));
          }
          return BlocBuilder<HomeDataCubit, HomeDataState>(
            builder: (context, state) {
              final cubit = HomeDataCubit.get(context);
              return state.when(
                onLoading: () => const IntroScreen(),
                onLoaded: (homeData) => ListHomeBuilder(homeData: homeData),
                onError: (error) =>
                error.isConnectionError
                    ? InternetUnavailabilityScreen(
                    onRetry: () => cubit.getData())
                    : ErrorStateWidget(error: error.message,
                    onRetry: () => cubit.getData()),
              );
            },
          );
        }
    );
  }
}