import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/countries_layout.dart';
import 'package:flutter/cupertino.dart';
import '../../shared/cubit/state.dart';
import 'cubit.dart';


class JapaneseScreen extends StatelessWidget {
  JapaneseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    JapaneseCubit.get(context).getData();
    return BlocBuilder<JapaneseCubit, CubitStates>(
      builder: (context, state) {
        final japaneseCubit = JapaneseCubit.get(context);
        final dataModelList = japaneseCubit.dataModelList;
        final isLoadingMore = japaneseCubit.isLoadingMore;
        return SearchableListBuilder(
            dataModel: dataModelList,
            searchData: japaneseCubit.searchData,
            context: context,
            title: 'المطبخ الياباني',
            getData: () => japaneseCubit.getData(),
            isLoadingMore: isLoadingMore,
            clearData: () => japaneseCubit.clearSearch(),
            dataSearch: (searchText) => japaneseCubit.getDataSearch(searchText)
        );
      },
    );
  }
}