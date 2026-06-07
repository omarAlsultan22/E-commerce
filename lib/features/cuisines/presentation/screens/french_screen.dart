import 'package:flutter/material.dart';
import '../cubits/french_data_cubit.dart';
import '../states/categories_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/lists/searchable_list_builder.dart';
import '../../../../core/presentation/widgets/states/initial_state_widget.dart';
import '../../../../core/presentation/widgets/states/loading_state_widget.dart';
import 'package:international_cuisine/core/presentation/states/loaded_states.dart';
import 'package:international_cuisine/features/cuisines/constants/cuisines_constants.dart';


class FrenchScreen extends StatefulWidget {
  const FrenchScreen({super.key});

  @override
  State<FrenchScreen> createState() => _FrenchScreenState();
}

class _FrenchScreenState extends State<FrenchScreen> {

  @override
  void initState() {
    super.initState();
    context.read<FrenchDataCubit>().getInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FrenchDataCubit, CategoriesState>(
      builder: (context, state) {
        final _cubit = context.read<FrenchDataCubit>();
        return state.when(
            onInitial: () =>
            const InitialStateWidget(
                CuisinesConstants.data, CuisinesConstants.menu),
            onLoading: () => const LoadingStateWidget(),
            onLoaded: (loadedState) {
              if (loadedState is SingleModelSuccessState) {
                SearchableListBuilder(
                  isLocked: false,
                  title: 'المطبخ الفرنسي',
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

