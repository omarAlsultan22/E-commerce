import 'package:international_cuisine/modules/egyptian/cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/countries_layout.dart';
import 'package:flutter/cupertino.dart';
import '../../shared/cubit/state.dart';


class EgyptianScreen extends StatelessWidget {
  EgyptianScreen({super.key});

  @override
  Widget build(BuildContext context) {
    EgyptianCubit.get(context).getData();
    return BlocBuilder<EgyptianCubit, CubitStates>(
      builder: (context, state) {
        final egyptianCubit = EgyptianCubit.get(context);
        final dataModelList = egyptianCubit.dataModelList;
        final isLoadingMore = egyptianCubit.isLoadingMore;
        return SearchableListBuilder(
            dataModel: dataModelList,
            searchData: egyptianCubit.searchData,
            context: context,
            title: 'المطبخ المصري',
            getData: () => egyptianCubit.getData(),
            isLoadingMore: isLoadingMore,
            clearData: () => egyptianCubit.clearSearch(),
            dataSearch: (searchText) => egyptianCubit.getDataSearch(searchText),

        );
      },
    );
  }
}