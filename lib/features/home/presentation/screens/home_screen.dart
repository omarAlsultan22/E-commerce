import 'package:international_cuisine/features/home/presentation/states/home_data_state.dart';
import '../../../../core/presentation/screens/connectivity_aware_screen.dart';
import '../../../../core/presentation/widgets/states/error_state_widget.dart';
import '../widgets/lists/list_home_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/home_data_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'intro_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ConnectivityAwareService(
        child: BlocBuilder<HomeDataCubit, HomeDataState>(
          builder: (context, state) {
            final cubit = context.read<HomeDataCubit>();
            return state.when(
              onLoading: () => const IntroScreen(),
              onLoaded: (homeData) => ListHomeBuilder(homeData: homeData),
              onError: (error) =>
                  ErrorStateWidget(error: error.message,
                      onRetry: () => cubit.getData()),
            );
          },
        )
    );
  }
}