import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:international_cuisine/shared/cubit/state.dart';
import '../../layout/countries_layout.dart';
import 'cubit.dart';

class TurkishScreen extends StatelessWidget {
  TurkishScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TurkishCubit.get(context).getData();
    return BlocConsumer<TurkishCubit, CubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = TurkishCubit.get(context);
        return SearchableListBuilder(
            dataModel: cubit.dataModelList,
            context: context,
            title: 'المطبخ التركي');
      },
    );
  }
}