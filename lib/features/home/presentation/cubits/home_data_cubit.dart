import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/presentation/mixins/error_handler_mixin.dart';
import 'package:international_cuisine/core/presentation/states/app_sub_states.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_provider.dart';
import 'package:international_cuisine/features/home/domain/useCases/home_data_useCase.dart';
import 'package:international_cuisine/features/home/presentation/states/home_data_state.dart';


class HomeDataCubit extends Cubit<HomeDataState> with ErrorHandlerMixin<HomeDataState> {
  final HomeDataUseCase _homeDataUseCase;
  final ConnectivityProvider _connectivityProvider;

  HomeDataCubit({
    required HomeDataUseCase homeDataUseCase,
    required ConnectivityProvider connectivityProvider
  })
      : _homeDataUseCase = homeDataUseCase,
        _connectivityProvider = connectivityProvider,
        super(
          HomeDataState.initial()
      );

  static HomeDataCubit get(context) => BlocProvider.of<HomeDataCubit>(context);

  void startMonitoring() {
    _connectivityProvider.addListener(_handleConnectionChange);
  }

  void _handleConnectionChange() {
    final isConnected = _connectivityProvider.isConnected;
    if (isConnected && state.dataISEmpty) {
      getData();
    }
  }

  Future<void> getData() async {
    emit(
        state.copyWith(
            subState: LoadingState()
        )
    );
    try {
      final homeData = await _homeDataUseCase.getDataExecute();

      if (homeData.isEmpty) {
        return;
      }

      emit(
          state.copyWith(
              subState: SuccessState(),
              firstModel: homeData
          )
      );
    } catch (e, stackTrace) {
      handleError(e, stackTrace,
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
  Future<void> close() {
    _connectivityProvider.removeListener(_handleConnectionChange);
    return super.close();
  }
}