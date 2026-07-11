import 'package:international_cuisine/features/cuisines/domain/useCases/cuisine_data_useCase.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_provider.dart';
import '../../../../core/presentation/states/app_sub_states.dart';
import '../../../../core/data/models/message_result.dart';
import '../../data/models/categories_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'base/base_data_cubit.dart';
import 'dart:io';


class JapaneseDataCubit extends BaseCountriesCubit {
  final CuisineDataUseCase _dataUseCases;
  final ConnectivityProvider _connectivityProvider;

  JapaneseDataCubit({
    required CuisineDataUseCase dataUseCases,
    required ConnectivityProvider connectivityProvider
  })
      : _dataUseCases = dataUseCases,
        _connectivityProvider = connectivityProvider;

  static JapaneseDataCubit get(BuildContext context) =>
      BlocProvider.of<JapaneseDataCubit>(context);

  static const _japanese = 'japanese';

  void startMonitoring() {
    _connectivityProvider.addListener(handleConnectionChange);
  }

  void handleConnectionChange() {
    if (_connectivityProvider.isConnected && state.firstModel == null) {
      getInitialData();
    }
  }

  @override
  Future<void> fetchData({required bool isLoadingMore}) async {
    if (!state.hasMore) return;

    if (!isLoadingMore && state.categoryDataIsEmpty) {
      emit(state.copyWith(subState: LoadingState()));
    }

    try {
      final newState = await _dataUseCases.getDataExecute(
          _japanese,
          isLoadingMore ? state.lastDocument : null
      );

      if(state.categoryDataIsEmpty && newState.isEmpty) {
        state.copyWith(subState: InitialState());
        return;
      }

      emit(state.copyWith(firstModel: CategoriesModel(
          categoryData: isLoadingMore
              ? [...state.categoryData, ...newState.dataList]
              : newState.dataList,
          lastDocument: newState.lastDocument,
          hasMore: newState.hasMoreData),
        subState: SuccessState(),
      ));
    } catch (e, stackTrace) {
      handleError(
          error: e,
          stackTrace: stackTrace,
          onError: (failure) =>
              state.copyWith(
                  subState: ErrorState(
                      failure: failure
                  )
              )
      );
    }
  }

  Future<void> getInitialData() async {
    if (!_connectivityProvider.isConnected && state.firstModel == null) {
      handleError(
          error: SocketException,
          stackTrace: StackTrace.current,
          onError: (failure) =>
          state.copyWith(
            subState: ErrorState(
              failure: failure
            ),
          )
      );
      return;
    }
    await fetchData(isLoadingMore: false);
  }

  Future<void> loadMoreData() async {
    if (!state.hasMore) return;
    await fetchData(isLoadingMore: true);
  }


  @override
  Future<void> updateRating({
    required int index,
    required int rating
  }) async {
    try {
      _dataUseCases.updateRatingExecute(
          collectionId: _japanese,
          index: index.toString(),
          rating: rating
      );
      final currentModel = state.currentDataModel(index);
      final newModel = currentModel.copyWith(rating: rating);
      emit(state.updateRating(index: index, newModel: newModel));
    }
    catch (e, stackTrace) {
      handleError(
          error: e,
          stackTrace: stackTrace,
          onError: (failure) =>
              state.copyWith(
                secondModel: MessageResult.error(error: failure),
              ));
    }
  }

  @override
  Future<void> getDataSearch(String searchText) async {
    try {
      final _searchData = await _dataUseCases.getDataSearchExecute(
          query: searchText, collectionPath: _japanese);

      emit(state.copyWith(firstModel: state.updateSearchList(_searchData)));
    }
    catch (e, stackTrace) {
      handleError(
          error: e,
          stackTrace: stackTrace,
          onError: (failure) =>
              state.copyWith(
                  subState: ErrorState(
                      failure: failure
                  )
              )
      );
    }
  }

  @override
  void clearDataSearch() {
    emit(state.copyWith(firstModel: state.updateSearchList([])));
  }

  @override
  Future<void> close() {
    _connectivityProvider.removeListener(handleConnectionChange);
    return super.close();
  }
}