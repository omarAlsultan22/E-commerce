import 'package:international_cuisine/features/cuisines/domain/useCases/cuisine_data_useCase.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_provider.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_service.dart';
import '../../../../core/errors/exceptions/network_exception.dart';
import '../../../../core/presentation/states/app_sub_states.dart';
import '../../../../core/errors/mappers/error_handler.dart';
import '../../data/models/categories_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'base/base_data_cubit.dart';


class ItalianDataCubit extends BaseCountriesCubit {
  final CuisineDataUseCase _dataUseCases;
  final ConnectivityProvider _connectivityProvider;

  ItalianDataCubit({
    required CuisineDataUseCase dataUseCases,
    required ConnectivityProvider connectivityProvider
  })
      : _dataUseCases = dataUseCases,
        _connectivityProvider = connectivityProvider;

  static ItalianDataCubit get(BuildContext context) =>
      BlocProvider.of<ItalianDataCubit>(context);

  static const _italian = 'italian';

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
      emit(state.updateState(subState: LoadingState()));
    }

    try {
      final newState = await _dataUseCases.getDataExecute(
          _italian,
          isLoadingMore ? state.lastDocument : null
      );

      emit(state.updateState(firstModel: CategoriesModel(
          categoryData: isLoadingMore
              ? [...state.categoryData, ...newState.dataList]
              : newState.dataList,
          lastDocument: newState.lastDocument,
          hasMore: newState.hasMoreData),
        subState: SuccessState(),
      ));
    } catch (e, stackTrace) {
      final errorHandler = ErrorHandler(
          error: e,
          stackTrace: stackTrace
      );
      final exception = errorHandler.handleException();
      emit(state.updateState(
        subState: ErrorState(failure: exception),
      ));
    }
  }

  Future<void> getInitialData() async {
    if (!_connectivityProvider.isConnected && state.firstModel == null) {
      final connectivityService = ConnectivityService();
      emit(
          state.updateState(
            subState: ErrorState(
              failure: AppNetworkException(
                  connectivityService: connectivityService
              ),
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
          collectionId: _italian,
          index: index.toString(),
          rating: rating
      );
      final currentModel = state.currentDataModel(index);
      final newModel = currentModel.copyWith(rating: rating);
      emit(state.updateRating(index: index, newModel: newModel));
    }
    catch (e, stackTrace) {
      final errorHandler = ErrorHandler(
          error: e,
          stackTrace: stackTrace
      );
      final exception = errorHandler.handleException();
      emit(state.updateState(
        subState: ErrorState(failure: exception),
      ));
    }
  }

  @override
  Future<void> getDataSearch(String searchText) async {
    try {
      final _searchData = await _dataUseCases.getDataSearchExecute(
          query: searchText, collectionPath: _italian);

      emit(state.updateState(firstModel: state.updateSearchList(_searchData)));
    }
    catch (e, stackTrace) {
      final errorHandler = ErrorHandler(
          error: e,
          stackTrace: stackTrace
      );
      final exception = errorHandler.handleException();
      emit(state.updateState(
        subState: ErrorState(failure: exception),
      ));
    }
  }

  @override
  void clearDataSearch() {
    emit(state.updateState(firstModel: state.updateSearchList([])));
  }

  @override
  Future<void> close() {
    _connectivityProvider.removeListener(handleConnectionChange);
    return super.close();
  }
}