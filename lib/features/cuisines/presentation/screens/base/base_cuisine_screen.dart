import 'package:flutter/material.dart';
import '../../states/categories_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/base/base_data_cubit.dart';
import '../../../constants/cuisines_constants.dart';
import '../../widgets/lists/searchable_list_builder.dart';
import '../../../../../core/presentation/widgets/appbar_widget.dart';
import '../../../../../core/presentation/widgets/states/initial_state_widget.dart';
import '../../../../../core/presentation/widgets/states/loading_state_widget.dart';


abstract class BaseCuisineScreen extends StatefulWidget {
  const BaseCuisineScreen({super.key});

  String get title;

  BaseCuisineCubit createCubit(BuildContext context);
}

abstract class BaseCuisineScreenState<T extends BaseCuisineScreen>
    extends State<T> {

  late BaseCuisineCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = widget.createCubit(context);
    cubit.getInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BaseCuisineCubit, CategoriesState>(
      builder: (context, state) {
        return state.when(
            onInitial: () =>
            const InitialStateWidget(
                CuisinesConstants.data,
                CuisinesConstants.menu
            ),
            onLoading: () => const LoadingStateWidget(),
            onLoaded: (data) {
              return SearchableListBuilder(
                isLocked: false,
                title: widget.title,
                categoriesModel: data.firstModel,
                messageResult: data.secondModel,
                getMoreData: () => cubit.loadMoreData(),
                clearData: () => cubit.clearDataSearch(),
                getSearchData: (searchText) => cubit.getDataSearch(searchText),
                updateRate: (index, rating) =>
                    cubit.updateRating(
                        index: index,
                        rating: rating
                    ),
              );
            },
            onError: (error) =>
                error.buildErrorWidget(
                  onRetry: cubit.getInitialData,
                  appBar: AppbarWidget.build(context),
                )
        );
      },
    );
  }
}