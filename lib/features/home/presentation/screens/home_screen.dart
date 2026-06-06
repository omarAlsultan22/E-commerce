import 'package:international_cuisine/features/home/presentation/states/home_data_state.dart';
import 'package:international_cuisine/core/presentation/states/loaded_states.dart';
import '../widgets/lists/list_home_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/home_data_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'intro_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeDataCubit, HomeDataState>(
      builder: (context, state) {
        final _cubit = context.read<HomeDataCubit>();
        return state.when(
            onInitial: () => SizedBox(),
            onLoading: () => const IntroScreen(),
            onLoaded: (loadedState) {
              if (loadedState is SingleModelSuccessState) {
                ListHomeBuilder(homeData: loadedState.firstModel);
              }
              return const IntroScreen();
            },
            onError: (error) =>
                error.buildErrorWidget(onRetry: _cubit.getData)
        );
      },
    );
  }
}