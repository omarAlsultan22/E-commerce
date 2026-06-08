import 'package:flutter/material.dart';
import '../states/categories_state.dart';
import '../cubits/italian_data_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/lists/searchable_list_builder.dart';
import 'package:international_cuisine/core/presentation/states/loaded_states.dart';
import 'package:international_cuisine/features/cuisines/constants/cuisines_constants.dart';
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
    context.read<ItalianDataCubit>().getInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItalianDataCubit, CategoriesState>(
      builder: (context, state) {
        final _cubit = context.read<ItalianDataCubit>();
        return state.when(
            onInitial: () =>
            const InitialStateWidget(
                CuisinesConstants.data, CuisinesConstants.menu),
            onLoading: () => const LoadingStateWidget(),
            onLoaded: (loadedState) {
              if (loadedState is DoubleModelSuccessState) {
                SearchableListBuilder(
                  isLocked: false,
                  title: 'المطبخ الايطالي',
                  categoriesModel: loadedState.firstModel,
                  messageResult: loadedState.secondModel,
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

