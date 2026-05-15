import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/useCases/sign_up_useCase.dart';
import '../../../../core/data/models/message_result.dart';
import '../../../../core/errors/mappers/error_handler.dart';
import '../../../../core/presentation/states/message_state.dart';
import '../../../../core/errors/exceptions/network_app_exception.dart';
import 'package:international_cuisine/core/constants/app_strings.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_service.dart';


class SignUpCubit extends Cubit<AuthState> {
  final SignUpUseCase _useCase;
  final ConnectivityService _connectivityService;

  SignUpCubit({
    required SignUpUseCase useCase,
    required ConnectivityService connectivityService,

  })
      : _useCase = useCase,
        _connectivityService = connectivityService,
        super(const AuthState());

  static SignUpCubit get(context) => BlocProvider.of(context);

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String userEmail,
    required String userPassword,
    required String userPhone,
    required String userLocation,
  }) async {
    final _isConnected = await _connectivityService.checkInternetConnection();
    if (!_isConnected) {
      emit(
        state.updateState(
          messageResult: MessageResult.error(
              error: NetworkAppException(message: AppStrings.noInternetMessage)),
        ),
      );
      return;
    }
    emit(AuthState(messageResult: MessageResult.loading()));
    try {
      await _useCase.signUpExecute(
        firstName: firstName,
        lastName: lastName,
        userEmail: userEmail,
        userPassword: userPassword,
        userPhone: userPhone,
        userLocation: userLocation,
      );
      emit(AuthState(
          messageResult: MessageResult.success()));
    } catch (e, stackTrace) {
      final errorHandler = ErrorHandler(
          error: e,
          stackTrace: stackTrace
      );
      final exception = errorHandler.handleException();
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