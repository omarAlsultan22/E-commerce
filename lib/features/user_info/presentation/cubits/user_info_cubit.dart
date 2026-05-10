import '../states/states/user_info_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/error_handler.dart';
import '../../domain/useCases/user_info_useCase.dart';
import '../../../../core/data/models/message_result.dart';
import '../../../../core/presentation/states/app_sub_states.dart';
import '../../../../core/errors/exceptions/network_exception.dart';
import '../../../../core/errors/exceptions/base/app_exception.dart';
import 'package:international_cuisine/core/constants/app_strings.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_provider.dart';
import 'package:international_cuisine/core/domain/services/connectivity_service/connectivity_service.dart';


class UserInfoCubit extends Cubit<UserInfoState> {
  final UserInfoUseCase _userInfoUseCase;
  final ConnectivityProvider _connectivityProvider;

  UserInfoCubit({
    required UserInfoUseCase userInfoUseCase,
    required ConnectivityProvider connectivityProvider
  })
      : _userInfoUseCase = userInfoUseCase,
        _connectivityProvider = connectivityProvider,
        super(UserInfoState(
          subState: InitialState()));

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
      return state.updateState(
          firstModel: state.userModel,
          secondModel: messageResult,
          subState: SuccessState()
      );
    }
    if (!_connectivityProvider.isConnected) {
      emit(
          buildState(
            MessageResult.error(
              error: NetworkException(message: AppStrings.noInternetMessage
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
        userLocation: userLocation,
      );
      emit(buildState(MessageResult.success()));
    }
    on AppException catch (e) {
      final exception = ErrorHandler.handleException(e);
      emit(
          buildState(
              MessageResult.error(
                error: exception,
              )
          )
      );
    }
  }

  Future<void> getInfo() async {
    if (!_connectivityProvider.isConnected && state.firstModel == null) {
      final _connectivityService = ConnectivityService();
      emit(state.updateState(
        subState: ErrorState(
          failure: NetworkException(connectivityService: _connectivityService),
        ),
      ));
      return;
    }
    emit(
        state.updateState(
            subState: LoadingState()));
    try {
      final userModel = await _userInfoUseCase.getInfoExecute();
      emit(
          state.updateState(
              firstModel: userModel,
              subState: SuccessState()));
    }
    on AppException catch (e) {
      final exception = ErrorHandler.handleException(e);
      emit(
          state.updateState(
              subState: ErrorState(
                  failure: exception
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
