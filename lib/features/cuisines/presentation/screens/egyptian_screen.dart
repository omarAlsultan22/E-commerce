import 'package:flutter/material.dart';
import '../states/categories_state.dart';
import '../cubits/egyptian_data_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/lists/searchable_list_builder.dart';
import 'package:international_cuisine/core/presentation/states/loaded_states.dart';
import 'package:international_cuisine/features/cuisines/constants/cuisines_constants.dart';
import 'package:international_cuisine/core/presentation/widgets/states/initial_state_widget.dart';
import 'package:international_cuisine/core/presentation/widgets/states/loading_state_widget.dart';


class EgyptianScreen extends StatefulWidget {
  const EgyptianScreen({super.key});

  @override
  State<EgyptianScreen> createState() => _EgyptianScreenState();
}

class _EgyptianScreenState extends State<EgyptianScreen> {

  @override
  void initState() {
    super.initState();
    context.read<EgyptianDataCubit>().getInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EgyptianDataCubit, CategoriesState>(
      builder: (context, state) {
        final _cubit = context.read<EgyptianDataCubit>();
        return state.when(
            onInitial: () =>
            const InitialStateWidget(
                CuisinesConstants.data, CuisinesConstants.menu),
            onLoading: () => const LoadingStateWidget(),
            onLoaded: (loadedState) {
              if (loadedState is SingleModelSuccessState) {
                SearchableListBuilder(
                  isLocked: false,
                  title: 'المطبخ المصري',
                  categoriesModel: loadedState.firstModel,
                  getMoreData: () => _cubit.loadMoreData(),
                  clearData: () => _cubit.clearDataSearch(),
                  getSearchData: (searchText) =>
                      _cubit.getDataSearch(searchText),
                  updateRate: (index, rating) =>
                      _cubit.updateRating(
                          index: index,
                          rating: rating
                      ),
                );
              }
              return const InitialStateWidget(
                  CuisinesConstants.data, CuisinesConstants.menu);
            },
            onError: (error) =>
                error.buildErrorWidget(onRetry: _cubit.getInitialData)
        );
      },
    );
  }
}

