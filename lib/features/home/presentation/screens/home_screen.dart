import 'package:international_cuisine/features/home/presentation/widgets/layouts/home_layout.dart';
import 'package:international_cuisine/features/home/presentation/states/home_data_state.dart';
import 'package:international_cuisine/core/presentation/states/loaded_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/home_model.dart';
import '../cubits/home_data_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'intro_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeDataCubit, HomeDataState>(
      builder: (context, state) {
        final _cubit = HomeDataCubit.get(context);
        return state.when(
            onInitial: () => SizedBox(),
            onLoading: () => const IntroScreen(),
            onLoaded: (loadedState) {
              if (loadedState is SingleModelSuccessState) {
                return HomeLayout(
                    homeData: loadedState.firstModel as List<HomeDataModel>
                );
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