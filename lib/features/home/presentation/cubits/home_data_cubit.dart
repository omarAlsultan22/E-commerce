import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/data/models/message_result.dart';
import '../../../auth/domain/useCases/sign_out_useCase.dart';
import '../../../../core/presentation/mixins/error_handler_mixin.dart';
import 'package:international_cuisine/core/presentation/states/app_sub_states.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_provider.dart';
import 'package:international_cuisine/features/home/domain/useCases/home_data_useCase.dart';
import 'package:international_cuisine/features/home/presentation/states/home_data_state.dart';


class HomeDataCubit extends Cubit<HomeDataState> with ErrorHandlerMixin<HomeDataState> {
  final SignOutUseCase _signOutUseCase;
  final HomeDataUseCase _homeDataUseCase;
  final ConnectivityProvider _connectivityProvider;

  HomeDataCubit({
    required SignOutUseCase signOutUseCase,
    required HomeDataUseCase homeDataUseCase,
    required ConnectivityProvider connectivityProvider
  })
      : _signOutUseCase = signOutUseCase,
        _homeDataUseCase = homeDataUseCase,
        _connectivityProvider = connectivityProvider,
        super(
          HomeDataState.initial()
      );

  static HomeDataCubit get(context) => BlocProvider.of<HomeDataCubit>(context);

  Future<void> getData() async {
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
    emit(
        state.copyWith(
            subState: LoadingState()
        )
    );
    try {
      final homeData = await _homeDataUseCase.getDataExecute();
      if (homeData.isEmpty) {
        emit(state.copyWith(subState: InitialState()));
        return;
      }

      emit(
          state.copyWith(
              subState: SuccessState(),
              firstModel: homeData
          )
      );
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

  Future<void> signOut() async {
    try {
      _signOutUseCase.signOutExecute();
      emit(
          state.copyWith(secondModel: MessageResult.success(message: 'تم تسجيل الخروج بنجاح')));
    } catch (e, stackTrace) {
      handleError(
          error: e,
          stackTrace: stackTrace,
          onError: (failure) =>
              state.copyWith(
                  secondModel: MessageResult.error(
                      error: failure, message: 'حدث خطأ أثناء تسجيل الخروج: '
                  )
              )
      );
    }
  }
}