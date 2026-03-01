import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:international_cuisine/core/presentation/states/app_state.dart';
import '../../states/categories_states.dart';


abstract class BaseCountriesCubit extends Cubit<CategoriesState> {
  BaseCountriesCubit()
      : super(CategoriesState(
      hasMore: true,
      appState: AppState(),
      categoryData: const [],
      searchData: const [],
  ));

  Future<void> getData();

  Future<void> updateRating({
    required int index,
    required int rating
  });

  Future<void> getDataSearch(String query);

  void clearDataSearch();
}

