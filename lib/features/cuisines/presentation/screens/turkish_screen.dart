import 'package:flutter/material.dart';
import '../states/categories_state.dart';
import '../cubits/turkish_data_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/lists/searchable_list_builder.dart';
import '../../../../core/presentation/widgets/appbar_widget.dart';
import 'package:international_cuisine/core/presentation/states/loaded_states.dart';
import 'package:international_cuisine/features/cuisines/constants/cuisines_constants.dart';
import 'package:international_cuisine/core/presentation/widgets/states/initial_state_widget.dart';
import 'package:international_cuisine/core/presentation/widgets/states/loading_state_widget.dart';


class TurkishScreen extends StatefulWidget {
  const TurkishScreen({super.key});

  @override
  State<TurkishScreen> createState() => _TurkishScreenState();
}

class _TurkishScreenState extends State<TurkishScreen> {

  @override
  void initState() {
    super.initState();
    context.read<TurkishDataCubit>().getInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TurkishDataCubit, CategoriesState>(
      builder: (context, state) {
        final _cubit = context.read<TurkishDataCubit>();
        return state.when(
            onInitial: () =>
            const InitialStateWidget(
                CuisinesConstants.data, CuisinesConstants.menu),
            onLoading: () => const LoadingStateWidget(),
            onLoaded: (loadedState) {
              final data = loadedState as DoubleModelSuccessState;
              return SearchableListBuilder(
                isLocked: false,
                title: 'المطبخ التركي',
                categoriesModel: data.firstModel,
                messageResult: data.secondModel,
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
            },
            onError: (error) =>
                error.buildErrorWidget(
                  onRetry: _cubit.getInitialData,
                  appBar: AppbarWidget.build(context),
                )
        );
      },
    );
  }
}

