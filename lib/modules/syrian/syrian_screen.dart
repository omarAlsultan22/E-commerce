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
    return BlocBuilder<SyrianCubit, CubitStates>(
      builder: (context, state) {
        final syrianCubit = SyrianCubit.get(context);
        final dataModelList = syrianCubit.dataModelList;
        final isLoadingMore = syrianCubit.isLoadingMore;
        return SearchableListBuilder(
            dataModel: dataModelList,
            searchData: syrianCubit.searchData,
            context: context,
            title: 'المطبخ السوري',
            getData: () => syrianCubit.getData(),
            isLoadingMore: isLoadingMore,
            clearData: () => syrianCubit.clearSearch(),
            dataSearch: (searchText) => syrianCubit.getDataSearch(searchText)
        );
      },
    );
  }
}