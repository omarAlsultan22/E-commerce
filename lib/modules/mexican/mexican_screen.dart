import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/countries_layout.dart';
import '../../shared/cubit/state.dart';
import 'cubit.dart';

class MexicanScreen extends StatelessWidget {
  MexicanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MexicanCubit.get(context).getData();
    return BlocConsumer<MexicanCubit, CubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = MexicanCubit.get(context);
        return SearchableListBuilder(
            dataModel: cubit.dataModelList,
            context: context,
            title: 'المطبخ المكسيكي');
      },
    );
  }
}