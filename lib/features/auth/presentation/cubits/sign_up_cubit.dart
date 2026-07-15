import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/useCases/sign_up_useCase.dart';
import '../../../../core/data/models/message_result.dart';
import '../../../../core/presentation/states/message_state.dart';
import '../../../../core/presentation/mixins/error_handler_mixin.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_provider.dart';


class SignUpCubit extends Cubit<MessageState> with ErrorHandlerMixin<MessageState> {
  final SignUpUseCase _useCase;
  final ConnectivityProvider _connectivityProvider;

  SignUpCubit({
    required SignUpUseCase useCase,
    required ConnectivityProvider connectivityProvider
  })
      : _useCase = useCase,
        _connectivityProvider = connectivityProvider,
        super(MessageState.initial());

  static SignUpCubit get(context) => BlocProvider.of(context);

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String userEmail,
    required String userPassword,
    required String userPhone,
    required String userLocation,
  }) async {
    if (!_connectivityProvider.isConnected) {
      handleError(
          error: SocketException,
          stackTrace: StackTrace.current,
          onError: (failure) =>
              MessageState(
                messageResult: MessageResult.error(
                    error: failure
                ),
              )
      );
      return;
    }

    emit(MessageState(messageResult: MessageResult.loading()));

    try {
      await _useCase.signUpExecute(
        firstName: firstName,
        lastName: lastName,
        userEmail: userEmail,
        userPassword: userPassword,
        userPhone: userPhone,
        userLocation: userLocation,
      );
      emit(MessageState(
          messageResult: MessageResult.success(message: 'تم انشاء الحساب بنجاح')));
    } catch (e, stackTrace) {
      handleError(
          error: e,
          stackTrace: stackTrace,
          onError: (failure) =>
              MessageState(messageResult: MessageResult.error(error: failure, message: 'فشل انشاء الحساب: ')
              )
      );
    }
  }
}