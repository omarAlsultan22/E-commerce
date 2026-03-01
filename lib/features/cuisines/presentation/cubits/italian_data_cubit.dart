import 'package:international_cuisine/features/cuisines/domain/useCases/cuisine_data_useCase.dart';
import 'package:international_cuisine/core/errors/exceptions/app_exception.dart';
import 'package:international_cuisine/core/errors/error_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'base/base_data_cubit.dart';


class ItalianDataCubit extends BaseCountriesCubit {
  final CuisineDataUseCase _dataUseCases;

  ItalianDataCubit({
    required CuisineDataUseCase dataUseCases,

  })
      : _dataUseCases = dataUseCases;

  static ItalianDataCubit get(BuildContext context) =>
      BlocProvider.of<ItalianDataCubit>(context);

  static const String italian = 'italian';

  Future<void> getData() async {
    if (!state.hasMore!) return;

    final appState = state.appState!;
    try {
      final newState = await _dataUseCases.getDataExecute(
          italian,
          state.lastDocument
      );
      emit(state.copyWith(
          appState: appState.copyWith(isLoading: false),
          categoryData: [...state.categoryData!, ...newState.dataList],
          lastDocument: newState.lastDocument,
          hasMore: newState.hasMoreData)
      );
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
          collectionId: italian,
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
          query: searchText, collectionPath: italian);

      emit(state.copyWith(searchData: _searchData));
    }
    on AppException catch (e) {
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