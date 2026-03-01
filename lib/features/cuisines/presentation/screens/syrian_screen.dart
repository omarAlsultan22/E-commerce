import 'package:flutter/material.dart';
import '../cubits/syrian_data_cubit.dart';
import '../states/categories_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/lists/searchable_list_builder.dart';
import '../../../../core/presentation/widgets/states/error_state_widget.dart';
import 'package:international_cuisine/features/cuisines/constants/constants_cuisines.dart';
import 'package:international_cuisine/core/presentation/screens/connectivity_aware_screen.dart';
import 'package:international_cuisine/core/presentation/widgets/states/initial_state_widget.dart';
import 'package:international_cuisine/core/presentation/widgets/states/loading_state_widget.dart';


class SyrianScreen extends StatefulWidget {
  const SyrianScreen({super.key});

  @override
  State<SyrianScreen> createState() => _SyrianScreenState();
}

class _SyrianScreenState extends State<SyrianScreen> {

  @override
  void initState() {
    super.initState();
    context.read<SyrianDataCubit>().getData();
  }

  @override
  Widget build(BuildContext context) {
    const syrianCuisine = 'المطبخ السوري';
    return ConnectivityAwareService(
        child: BlocBuilder<SyrianDataCubit, CategoriesState>(
            builder: (context, state) {
              final _cubit = context.read<SyrianDataCubit>();
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
                        title: syrianCuisine,
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
            }
        )
    );
  }
}

