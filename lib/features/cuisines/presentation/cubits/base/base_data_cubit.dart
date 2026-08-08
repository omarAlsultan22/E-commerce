import 'dart:io';
import '../../states/categories_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/categories_model.dart';
import '../../../domain/useCases/cuisine_data_useCase.dart';
import '../../../../../core/data/models/message_result.dart';
import '../../../../../core/presentation/states/app_sub_states.dart';
import '../../../../../core/presentation/mixins/error_handler_mixin.dart';
import '../../../../../core/domain/services/connectivity_service/connectivity_provider.dart';


abstract class BaseCuisineCubit extends Cubit<CategoriesState> with ErrorHandlerMixin<CategoriesState> {
  final CuisineDataUseCase _dataUseCases;
  final ConnectivityProvider _connectivityProvider;

  BaseCuisineCubit({
    required CuisineDataUseCase dataUseCases,
    required ConnectivityProvider connectivityProvider
  })
      : _dataUseCases = dataUseCases,
        _connectivityProvider = connectivityProvider,
        super(CategoriesState.initial());

  String get cuisineName;

  Future<void> fetchData({required bool isLoadingMore}) async {
    if (!state.hasMore) return;

    if (!isLoadingMore && state.categoryDataIsEmpty) {
      emit(state.copyWith(subState: LoadingState()));
    }

    try {
      final newState = await _dataUseCases.getDataExecute(
          cuisineName,
          isLoadingMore ? state.lastDocument : null
      );

      if (state.categoryDataIsEmpty && newState.isEmpty) {
        emit(state.copyWith(subState: InitialState()));
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


  Future<void> updateRating({
    required int index,
    required int rating
  }) async {
    try {
      _dataUseCases.updateRatingExecute(
          collectionId: cuisineName,
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
              )
      );
    }
  }

  Future<void> getDataSearch(String searchText) async {
    try {
      final _searchData = await _dataUseCases.getDataSearchExecute(
          query: searchText, collectionPath: cuisineName);

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

  void clearDataSearch() {
    emit(state.copyWith(firstModel: state.updateSearchList([])));
  }
}

