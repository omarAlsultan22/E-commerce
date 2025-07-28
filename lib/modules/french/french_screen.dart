import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/countries_layout.dart';
import '../../shared/cubit/state.dart';
import 'cubit.dart';

class FrenchScreen extends StatelessWidget {
  FrenchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FrenchCubit.get(context).getData();
    return BlocConsumer<FrenchCubit, CubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = FrenchCubit.get(context);
        return SearchableListBuilder(
            dataModel: cubit.dataModelList,
            context: context,
            title: 'المطبخ الفرنسي');
      },
    );
  }
}