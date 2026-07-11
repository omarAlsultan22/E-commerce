import 'dart:io';
import '../states/states/user_info_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/useCases/user_info_useCase.dart';
import '../../../../core/data/models/message_result.dart';
import '../../../../core/presentation/states/app_sub_states.dart';
import '../../../../core/presentation/mixins/error_handler_mixin.dart';
import '../../../../core/errors/exceptions/network_app_exception.dart';
import 'package:international_cuisine/core/constants/app_strings.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_provider.dart';


class UserInfoCubit extends Cubit<UserInfoState> with ErrorHandlerMixin<UserInfoState>{
  final UserInfoUseCase _userInfoUseCase;
  final ConnectivityProvider _connectivityProvider;

  UserInfoCubit({
    required UserInfoUseCase userInfoUseCase,
    required ConnectivityProvider connectivityProvider
  })
      : _userInfoUseCase = userInfoUseCase,
        _connectivityProvider = connectivityProvider,
        super(UserInfoState.initial());

  static UserInfoCubit get(context) => BlocProvider.of(context);

  void startMonitoring() {
    _connectivityProvider.addListener(_handleConnectionChange);
  }

  void _handleConnectionChange() {
    if (_connectivityProvider.isConnected && state.userModel == null) {
      getInfo();
    }
  }

  Future<void> updateInfo({
    required String firstName,
    required String lastName,
    required String userPhone,
    required String userLocation
  }) async {
    UserInfoState buildState(MessageResult messageResult) {
      return state.copyWith(
          firstModel: state.userModel,
          secondModel: messageResult,
          subState: SuccessState()
      );
    }
    if (!_connectivityProvider.isConnected) {
      emit(
          buildState(
            MessageResult.error(
              error: NetworkAppException(message: AppStrings.noInternetMessage
              ),
            ),
          )
      );
      return;
    }

    emit(buildState(MessageResult.loading()));

    try {
      await _userInfoUseCase.updateInfoExecute(
        firstName: firstName,
        lastName: lastName,
        userPhone: userPhone,
        userLocation: userLocation
      );
      emit(buildState(MessageResult.success()));
    }
    catch (e, stackTrace) {
      handleError(
          error: e,
          stackTrace: stackTrace,
          onError: (failure) =>
          buildState(
              MessageResult.error(
                error: failure,
              )
          )
      );
    }
  }

  Future<void> getInfo() async {
    if (!_connectivityProvider.isConnected && state.firstModel == null) {
      handleError(
          error: SocketException,
          stackTrace: StackTrace.current,
          onError: (failure) =>
              state.copyWith(
                subState: ErrorState(
                  failure: failure,
                ),
              )
      );
      return;
    }
    emit(
        state.copyWith(
            subState: LoadingState()));
    try {
      final userInfo = await _userInfoUseCase.getInfoExecute();

      if(userInfo == null) {
        state.copyWith(subState: InitialState());
        return;
      }

      emit(
          state.copyWith(
              firstModel: userInfo,
              subState: SuccessState()));
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
  Future<void> close() {
    _connectivityProvider.removeListener(_handleConnectionChange);
    return super.close();
  }
}
