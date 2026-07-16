import 'package:flutter/material.dart';
import '../states/categories_state.dart';
import '../cubits/japanese_data_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/lists/searchable_list_builder.dart';
import '../../../../core/presentation/widgets/appbar_widget.dart';
import 'package:international_cuisine/core/presentation/states/loaded_states.dart';
import 'package:international_cuisine/features/cuisines/constants/cuisines_constants.dart';
import 'package:international_cuisine/core/presentation/widgets/states/initial_state_widget.dart';
import 'package:international_cuisine/core/presentation/widgets/states/loading_state_widget.dart';


class JapaneseScreen extends StatefulWidget {
  const JapaneseScreen({super.key});

  @override
  State<JapaneseScreen> createState() => _JapaneseScreenState();
}

class _JapaneseScreenState extends State<JapaneseScreen> {

  @override
  void initState() {
    super.initState();
    context.read<JapaneseDataCubit>().getInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JapaneseDataCubit, CategoriesState>(
      builder: (context, state) {
        final _cubit = context.read<JapaneseDataCubit>();
        return state.when(
            onInitial: () =>
            const InitialStateWidget(
                CuisinesConstants.data, CuisinesConstants.menu),
            onLoading: () => const LoadingStateWidget(),
            onLoaded: (loadedState) {
              final data = loadedState as DoubleModelSuccessState;
              return SearchableListBuilder(
                isLocked: false,
                title: 'المطبخ الياباني',
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

