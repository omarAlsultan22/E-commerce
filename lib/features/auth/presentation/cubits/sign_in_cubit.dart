import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/useCases/sign_in_useCase.dart';
import '../../../../core/data/models/message_result.dart';
import '../../../../core/presentation/states/message_state.dart';
import '../../../../core/errors/exceptions/network_app_exception.dart';
import '../../../../core/presentation/mixins/error_handler_mixin.dart';
import 'package:international_cuisine/core/errors/exceptions/validation_exception.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_provider.dart';


class SignInCubit extends Cubit<MessageState> with ErrorHandlerMixin<MessageState> {
  final SignInUseCase _useCase;
  final ConnectivityProvider _connectivityProvider;

  SignInCubit({
    required SignInUseCase useCase,
    required ConnectivityProvider connectivityProvider
  })
      : _useCase = useCase,
        _connectivityProvider = connectivityProvider,
        super(MessageState.initial());

  static SignInCubit get(context) => BlocProvider.of(context);

  Future<void> signIn({
    required String userEmail,
    required String userPassword,
  }) async {
    if (!_connectivityProvider.isConnected) {
      throw NetworkAppException();
    }
    if (userEmail.isEmpty || userPassword.isEmpty) {
      throw ValidationException();
    }

    emit(MessageState(messageResult: MessageResult.loading()));

    try {
      await _useCase.signInExecute(
          userEmail: userEmail,
          userPassword: userPassword
      );
      emit(MessageState(
          messageResult: MessageResult.success(
              message: 'تم تسجيل الدخول بنجاح')));
    } catch (e, stackTrace) {
      handleError(
          error: e,
          stackTrace: stackTrace,
          onError: (failure) =>
              MessageState(
                  messageResult: MessageResult.error(
                      error: failure)
              )
      );
    }
  }
}