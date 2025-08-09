import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:international_cuisine/layout/countries_layout.dart';
import 'package:international_cuisine/modules/chinese/cubit.dart';
import '../../shared/cubit/state.dart';

class ChineseScreen extends StatelessWidget {
  ChineseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ChineseCubit.get(context).getData();
    return BlocConsumer<ChineseCubit, CubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final chineseCubit = ChineseCubit.get(context);
        final dataModelList = chineseCubit.dataModelList;
        final isLoadingMore = chineseCubit.isLoadingMore;
        return SearchableListBuilder(
            dataModel: dataModelList,
            searchData: [],
            context: context,
            title: 'المطبخ الصيني',
            onPressed: () => chineseCubit.getData(),
            isLoadingMore: isLoadingMore,
            clearData: () => chineseCubit.clearSearch(),
            getData: (searchText) => chineseCubit.getDataSearch(searchText)
        );
      },
    );
  }
}

