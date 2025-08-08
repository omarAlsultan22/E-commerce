import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:international_cuisine/modules/egyptian/cubit.dart';
import 'package:international_cuisine/shared/cubit/state.dart';
import '../../layout/countries_layout.dart';
import 'cubit.dart';

class TurkishScreen extends StatelessWidget {
  TurkishScreen({super.key});

  @override
  Widget build(BuildContext context) {
    EgyptianCubit.get(context).getData();
    return BlocConsumer<TurkishCubit, CubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final turkishCubit = TurkishCubit.get(context);
        final dataModelList = turkishCubit.dataModelList;
        final isLoadingMore = turkishCubit.isLoadingMore;
        return SearchableListBuilder(
            dataModel: dataModelList,
            context: context,
            title: 'المطبخ التركي',
            onPressed: () => turkishCubit.getData(),
            isLoadingMore: isLoadingMore);
      },
    );
  }
}