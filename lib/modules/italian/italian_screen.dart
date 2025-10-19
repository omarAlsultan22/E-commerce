import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/countries_layout.dart';
import 'package:flutter/cupertino.dart';
import '../../shared/cubit/state.dart';
import 'cubit.dart';


class ItalianScreen extends StatelessWidget {
  ItalianScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ItalianCubit.get(context).getData();
    return BlocBuilder<ItalianCubit, CubitStates>(
      builder: (context, state) {
        final italianCubit = ItalianCubit.get(context);
        final dataModelList = italianCubit.dataModelList;
        final isLoadingMore = italianCubit.isLoadingMore;
        return SearchableListBuilder(
            dataModel: dataModelList,
            searchData: italianCubit.searchData,
            context: context,
            title: 'المطبخ الايطالي',
            getData: () => italianCubit.getData(),
            isLoadingMore: isLoadingMore,
            clearData: () => italianCubit.clearSearch(),
            dataSearch: (searchText) => italianCubit.getDataSearch(searchText)
        );
      },
    );
  }
}