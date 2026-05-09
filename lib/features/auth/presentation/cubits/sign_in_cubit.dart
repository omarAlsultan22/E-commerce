import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/useCases/sign_in_useCase.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/data/models/message_result.dart';
import '../../../../core/presentation/states/message_state.dart';
import '../../../../core/errors/exceptions/network_exception.dart';
import '../../../../core/errors/exceptions/base/app_exception.dart';
import 'package:international_cuisine/core/constants/app_states.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_service.dart';


class SignInCubit extends Cubit<AuthState> {
  final SignInUseCase _useCase;
  final ConnectivityService _connectivityService;

  SignInCubit({
    required SignInUseCase useCase,
    required ConnectivityService connectivityService
  })
      : _useCase = useCase,
        _connectivityService = connectivityService,
        super(const AuthState());

  static SignInCubit get(context) => BlocProvider.of(context);

  Future<void> signIn({
    required String userEmail,
    required String userPassword,
  }) async {
    final _isConnected = await _connectivityService.checkInternetConnection();
    if (!_isConnected) {
      emit(
        state.updateState(
          messageResult: MessageResult.error(
              error: NetworkException(message: AppStates.noInternetMessage)),
        ),
      );
      return;
    }
    emit(AuthState(messageResult: MessageResult.loading()));
    try {
      if (userEmail.isEmpty || userPassword.isEmpty) {
        throw('Fields cannot be empty.');
      }
      _useCase.signInExecute(
          userEmail: userEmail,
          userPassword: userPassword
      );
      emit(AuthState(
          messageResult: MessageResult.success()));
    } on AppException catch (e) {
      final exception = ErrorHandler.handleException(e);
      emit(
          AuthState(
              messageResult: MessageResult.error(
                  error: exception
              )
          )
      );
    }
  }
}