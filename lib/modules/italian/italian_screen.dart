import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/countries_layout.dart';
import '../../shared/cubit/state.dart';
import 'cubit.dart';

class ItalianScreen extends StatelessWidget {
  ItalianScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ItalianCubit.get(context).getData();
    return BlocConsumer<ItalianCubit, CubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = ItalianCubit.get(context);
        return SearchableListBuilder(
            dataModel: cubit.dataModelList,
            context: context,
            title: 'المطبخ الايطالي');
      },
    );
  }
}