import 'package:international_cuisine/core/presentation/states/app_sub_states.dart';

import '../../states/categories_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:international_cuisine/features/cuisines/data/models/categories_model.dart';


abstract class BaseCountriesCubit extends Cubit<CategoriesState> {
  BaseCountriesCubit()
      : super(
      CategoriesState.initial()
  );

  void startMonitoring();

  void handleConnectionChange();

  Future<void> fetchData({required bool isLoadingMore});

  Future<void> updateRating({
    required int index,
    required int rating
  });

  Future<void> getDataSearch(String query);

  void clearDataSearch();
}

