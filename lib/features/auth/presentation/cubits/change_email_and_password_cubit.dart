import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/data/models/message_result.dart';
import '../../../../core/errors/mappers/error_handler.dart';
import '../../../../core/presentation/states/message_state.dart';
import '../../domain/useCases/change_email_and_password_useCase.dart';
import 'package:international_cuisine/core/constants/app_strings.dart';
import 'package:international_cuisine/core/errors/exceptions/network_app_exception.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_service.dart';


class ChangeEmailAndPasswordCubit extends Cubit<AuthState> {
  final ChangeEmailAndPasswordUseCase _useCase;
  final ConnectivityService _connectivityService;

  ChangeEmailAndPasswordCubit({
    required ChangeEmailAndPasswordUseCase useCase,
    required ConnectivityService connectivityService
  })
      : _useCase = useCase,
        _connectivityService = connectivityService,
        super(const AuthState());

  static ChangeEmailAndPasswordCubit get(context) => BlocProvider.of(context);

  Future<void> changeEmailAndPassword({
    required String newEmail,
    required String currentPassword,
    required String newPassword,
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
      _useCase.updateProfileExecute(
          newEmail: newEmail,
          newPassword: newPassword,
          currentPassword: currentPassword
      );
      emit(
          AuthState(messageResult: MessageResult.success()));
    } catch (e, stackTrace) {
      final errorHandler = ErrorHandler(
          error: e,
          stackTrace: stackTrace
      );
      final exception = errorHandler.handleException();
      emit(AuthState(messageResult: MessageResult.error(
          error: exception)));
    }
  }
}