import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/error_handler.dart';
import 'package:international_cuisine/core/errors/exceptions/app_exception.dart';
import 'package:international_cuisine/features/home/domain/useCases/home_data_useCase.dart';
import 'package:international_cuisine/features/home/presentation/states/home_data_state.dart';


class HomeDataCubit extends Cubit<HomeDataState> {
  HomeDataUseCase _homeDataUseCase;

  HomeDataCubit({
    required HomeDataUseCase homeDataUseCase
  })
      : _homeDataUseCase = homeDataUseCase,
        super(HomeDataState());

  static HomeDataCubit get(context) => BlocProvider.of(context);

  Future<void> getData() async {

    final appState = state.appState!;
    emit(state.copyWith(
        appState: appState.copyWith(isLoading: true, failure: null))
    );
    try {
      final data = await _homeDataUseCase.getDataExecute();
      emit(state.copyWith(
          homeDataList: data, appState: appState.copyWith(isLoading: false))
      );
    } on AppException catch (e) {
      final exception = ErrorHandler.handleException(e);
      emit(state.copyWith(
          appState: appState.copyWith(isLoading: false, failure: exception))
      );
    }
  }
}