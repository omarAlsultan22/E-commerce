import 'package:flutter/material.dart';
import '../states/categories_states.dart';
import '../cubits/italian_data_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/lists/searchable_list_builder.dart';
import '../../../../core/presentation/screens/connectivity_aware_screen.dart';
import '../../../../core/presentation/widgets/states/error_state_widget.dart';
import 'package:international_cuisine/features/cuisines/constants/constants_cuisines.dart';
import 'package:international_cuisine/core/presentation/widgets/states/initial_state_widget.dart';
import 'package:international_cuisine/core/presentation/widgets/states/loading_state_widget.dart';


class ItalianScreen extends StatefulWidget {
  const ItalianScreen({super.key});

  @override
  State<ItalianScreen> createState() => _ItalianScreenState();
}

class _ItalianScreenState extends State<ItalianScreen> {

  @override
  void initState() {
    super.initState();
    context.read<ItalianDataCubit>().getData();
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityAwareService(
        child: BlocBuilder<ItalianDataCubit, CategoriesState>(
          builder: (context, state) {
            final _cubit = context.read<ItalianDataCubit>();
            return state.when(
                onInitial: () =>
                const InitialStateWidget(
                    ConstantsCuisines.data, ConstantsCuisines.menu),
                onLoading: () => const LoadingStateWidget(),
                onLoaded: (categoryData, searchData) =>
                    SearchableListBuilder(
                      isLocked: false,
                      dataList: categoryData!,
                      searchData: searchData!,
                      title: 'المطبخ الايطالي',
                      getMoreData: () => _cubit.getData(),
                      hasMore: state.hasMore!,
                      clearData: () => _cubit.clearDataSearch(),
                      getSearchData: (searchText) =>
                          _cubit.getDataSearch(searchText),
                      updateRate: (index, rating) =>
                          _cubit.updateRating(
                              index: index,
                              rating: rating
                          ),
                    ),
                onError: (error) =>
                    ErrorStateWidget(
                        error: error.message,
                        onRetry: () => _cubit.getData())
            );
          },
        )
    );
  }
}

