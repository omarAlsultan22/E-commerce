import 'package:flutter_bloc/flutter_bloc.dart';
import '../../states/categories_states.dart';


abstract class BaseCountriesCubit extends Cubit<CategoriesState> {
  BaseCountriesCubit()
      : super(CategoriesState(categoryData: [], searchData: []));

  Future<void> getData();

  Future<void> updateRating({
    required int index,
    required int rating
  });

  Future<void> getDataSearch(String query);

  void clearDataSearch();
}

