import 'package:flutter/material.dart';
import '../states/categories_states.dart';
import '../cubits/egyptian_data_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/lists/searchable_list_builder.dart';
import '../../../../core/presentation/widgets/states/error_state_widget.dart';
import 'package:international_cuisine/core/presentation/widgets/states/initial_state_widget.dart';
import 'package:international_cuisine/core/presentation/widgets/states/loading_state_widget.dart';
import '../../../../core/presentation/screens/internet_unavailability_screen.dart';


class EgyptianScreen extends StatelessWidget {
  EgyptianScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EgyptianDataCubit, CategoriesState>(
      builder: (context, state) {
        final _context = EgyptianDataCubit.get(context);
        return state.when(
            onInitial: () => const InitialStateWidget('data', Icons.menu),
            onLoading: () => const LoadingStateWidget(),
            onLoaded: (categoryData, searchData) =>
                SearchableListBuilder(
                  dataModel: categoryData!,
                  searchData: searchData!,
                  title: 'المطبخ المصري',
                  getData: () => _context.getData(),
                  hasMore: state.hasMore!,
                  clearData: () => _context.clearDataSearch(),
                  dataSearch: (searchText) =>
                      _context.getDataSearch(searchText),
                  updateRate: (index, rating) =>
                      _context.updateRating(
                          index: index,
                          rating: rating
                      ),
                ),
            onError: (error) =>
            error.isConnectionError ? ErrorStateWidget(
                error: error.message,
                onRetry: () => _context.getData()) : Center(
                child: InternetUnavailabilityScreen(
                    onRetry: () => _context.getData()
                )
            )
        );
      },
    );
  }
}

