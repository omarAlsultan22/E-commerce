import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/countries_layout.dart';
import '../../shared/cubit/state.dart';
import 'cubit.dart';

class JapaneseScreen extends StatelessWidget {
  JapaneseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    JapaneseCubit.get(context).getData();
    return BlocConsumer<JapaneseCubit, CubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final japaneseCubit = JapaneseCubit.get(context);
        final dataModelList = japaneseCubit.dataModelList;
        final isLoadingMore = japaneseCubit.isLoadingMore;
        return SearchableListBuilder(
            dataModel: dataModelList,
            context: context,
            title: 'المطبخ الياباني',
            onPressed: () => japaneseCubit.getData(),
            isLoadingMore: isLoadingMore
        );
      },
    );
  }
}