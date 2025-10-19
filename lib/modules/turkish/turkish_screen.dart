import 'package:international_cuisine/modules/egyptian/cubit.dart';
import 'package:international_cuisine/shared/cubit/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/countries_layout.dart';
import 'package:flutter/cupertino.dart';
import 'cubit.dart';


class TurkishScreen extends StatelessWidget {
  TurkishScreen({super.key});

  @override
  Widget build(BuildContext context) {
    EgyptianCubit.get(context).getData();
    return BlocBuilder<TurkishCubit, CubitStates>(
      builder: (context, state) {
        final turkishCubit = TurkishCubit.get(context);
        final dataModelList = turkishCubit.dataModelList;
        final isLoadingMore = turkishCubit.isLoadingMore;
        return SearchableListBuilder(
            dataModel: dataModelList,
            searchData: turkishCubit.searchData,
            context: context,
            title: 'المطبخ التركي',
            getData: () => turkishCubit.getData(),
            isLoadingMore: isLoadingMore,
            clearData: () => turkishCubit.clearSearch(),
            dataSearch: (searchText) => turkishCubit.getDataSearch(searchText)
        );
      },
    );
  }
}