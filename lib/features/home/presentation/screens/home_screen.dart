import 'package:international_cuisine/features/home/presentation/widgets/layouts/home_layout.dart';
import 'package:international_cuisine/features/home/presentation/states/home_data_state.dart';
import 'package:international_cuisine/core/presentation/states/loaded_states.dart';
import '../../../../core/presentation/widgets/states/initial_state_widget.dart';
import '../../../../core/presentation/widgets/appbar_widget.dart';
import '../../../cuisines/constants/cuisines_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import '../cubits/home_data_cubit.dart';
import 'intro_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeDataCubit, HomeDataState>(
      builder: (context, state) {
        final _cubit = HomeDataCubit.get(context);
        return state.when(
            onInitial: () =>
            const InitialStateWidget(
                CuisinesConstants.data, CuisinesConstants.menu),
            onLoading: () => const IntroScreen(),
            onLoaded: (loadedState) {
              final data = loadedState as DoubleModelSuccessState;
              return HomeLayout(
                signOut: _cubit.signOut,
                homeData: data.firstModel,
                messageResult: data.secondModel,
              );
            },
            onError: (error) =>
                error.buildErrorWidget(
                    appBar: null,
                    onRetry: _cubit.getData
                )
        );
      },
    );
  }
}