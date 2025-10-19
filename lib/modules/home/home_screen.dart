import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import '../../layout/home_layout.dart';
import '../../shared/cubit/state.dart';
import 'cubit.dart';


class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, CubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final HomeModel = HomeCubit
            .get(context)
            .dataModelList;
        return ListHomeBuilder(
          homeModel: HomeModel,
        );
      },
    );
  }
}