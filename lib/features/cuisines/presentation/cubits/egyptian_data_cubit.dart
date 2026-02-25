import 'package:international_cuisine/features/cuisines/domain/useCases/cuisine_data_useCase.dart';
import 'package:international_cuisine/core/errors/exceptions/app_exception.dart';
import 'package:international_cuisine/core/constants/cuisines_names.dart';
import 'package:international_cuisine/core/errors/error_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'base/base_data_cubit.dart';


class EgyptianDataCubit extends BaseCountriesCubit {
  final CuisineDataUseCase _dataUseCases;

  EgyptianDataCubit({
    required CuisineDataUseCase dataUseCases,

  })
      : _dataUseCases = dataUseCases;

  static EgyptianDataCubit get(BuildContext context) =>
      BlocProvider.of<EgyptianDataCubit>(context);

  Future<void> getData() async {
    final appState = state.appState!;

    try {
      final newState = await _dataUseCases.getDataExecute(
          state, CountriesNames.egyptian);
      emit(newState.copyWith(appState: appState.copyWith(isLoading: false)));
    } on AppException catch (e) {
      final failure = ErrorHandler.handleException(e);
      emit(state.copyWith(
          appState: appState.copyWith(isLoading: false, failure: failure)));
    }
  }

  @override
  Future<void> updateRating({
    required int index,
    required int rating
  }) async {
    final appState = state.appState!;

    try {
      _dataUseCases.updateRatingExecute(
          collectionId: CountriesNames.egyptian,
          index: index.toString(),
          rating: rating
      );
      final currentModel = state.currentDataModel(index);
      final newModel = currentModel.copyWith(rating: rating);
      emit(state.updateRating(index: index, newModel: newModel));
    }
    on AppException catch (e) {
      final failure = ErrorHandler.handleException(e);
      emit(state.copyWith(appState: appState.copyWith(failure: failure)));
    }
  }

  @override
  Future<void> getDataSearch(String searchText) async {
    final appState = state.appState!;

    try {
      final _searchData = await _dataUseCases.getDataSearchExecute(
          query: searchText, collectionPath: CountriesNames.egyptian);

      emit(state.copyWith(searchData: _searchData));
    } on AppException catch (e) {
      final failure = ErrorHandler.handleException(e);
      emit(state.copyWith(
          appState: appState.copyWith(failure: failure)));
    }
  }

  @override
  void clearDataSearch() {
    emit(state.copyWith(searchData: []));
  }
}