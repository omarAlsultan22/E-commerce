import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/countries_layout.dart';
import '../../shared/cubit/state.dart';
import 'cubit.dart';

class FrenchScreen extends StatelessWidget {
  FrenchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FrenchCubit.get(context).getData();
    return BlocConsumer<FrenchCubit, CubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final frenchCubit = FrenchCubit.get(context);
        final dataModelList = frenchCubit.dataModelList;
        final isLoadingMore = frenchCubit.isLoadingMore;
        return SearchableListBuilder(
            dataModel: dataModelList,
            searchData: frenchCubit.searchData,
            context: context,
            title: 'المطبخ الفرنسي',
            onPressed: () => frenchCubit.getData(),
            isLoadingMore: isLoadingMore,
            clearData: () => frenchCubit.clearSearch(),
            getData: (searchText) => frenchCubit.getDataSearch(searchText)
        );
      },
    );
  }
}