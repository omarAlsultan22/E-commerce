import '../../states/categories_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/presentation/mixins/error_handler_mixin.dart';


abstract class BaseCountriesCubit extends Cubit<CategoriesState> with ErrorHandlerMixin<CategoriesState> {
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

