import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/countries_layout.dart';
import 'package:flutter/cupertino.dart';
import '../../shared/cubit/state.dart';
import 'cubit.dart';


class MexicanScreen extends StatelessWidget {
  MexicanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MexicanCubit.get(context).getData();
    return BlocBuilder<MexicanCubit, CubitStates>(
      builder: (context, state) {
        final mexicanCubit = MexicanCubit.get(context);
        final dataModelList = mexicanCubit.dataModelList;
        final isLoadingMore = mexicanCubit.isLoadingMore;
        return SearchableListBuilder(
            dataModel: dataModelList,
            searchData: mexicanCubit.searchData,
            context: context,
            title: 'المطبخ المكسيكي',
            getData: () => mexicanCubit.getData(),
            isLoadingMore: isLoadingMore,
            clearData: () => mexicanCubit.clearSearch(),
            dataSearch: (searchText) => mexicanCubit.getDataSearch(searchText)
        );
      },
    );
  }
}