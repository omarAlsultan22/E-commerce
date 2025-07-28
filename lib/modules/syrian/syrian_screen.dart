import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/countries_layout.dart';
import '../../shared/cubit/state.dart';
import 'cubit.dart';

class SyrianScreen extends StatelessWidget {
  SyrianScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SyrianCubit.get(context).getData();
    return BlocConsumer<SyrianCubit, CubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SyrianCubit.get(context);
        return SearchableListBuilder(
            dataModel: cubit.dataModelList,
            context: context,
            title: 'المطبخ السوري');
      },
    );
  }
}