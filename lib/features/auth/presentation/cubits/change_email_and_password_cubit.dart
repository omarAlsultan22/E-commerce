import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/data/models/message_result.dart';
import '../../../../core/presentation/states/message_state.dart';
import '../../domain/useCases/change_email_and_password_useCase.dart';
import '../../../../core/presentation/mixins/error_handler_mixin.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_provider.dart';


class ChangeEmailAndPasswordCubit extends Cubit<MessageState> with ErrorHandlerMixin<MessageState> {
  final ChangeEmailAndPasswordUseCase _useCase;
  final ConnectivityProvider _connectivityProvider;

  ChangeEmailAndPasswordCubit({
    required ChangeEmailAndPasswordUseCase useCase,
    required ConnectivityProvider connectivityProvider
  })
      : _useCase = useCase,
        _connectivityProvider = connectivityProvider,
        super(MessageState.initial());

  static ChangeEmailAndPasswordCubit get(context) => BlocProvider.of(context);

  Future<void> changeEmailAndPassword({
    required String newEmail,
    required String currentPassword,
    required String newPassword,
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
      await _useCase.updateProfileExecute(
          newEmail: newEmail,
          newPassword: newPassword,
          currentPassword: currentPassword
      );
      emit(
          MessageState(messageResult: MessageResult.success()));
    } catch (e, stackTrace) {
      handleError(
          error: e,
          stackTrace: stackTrace,
          onError: (failure) =>
              MessageState(messageResult: MessageResult.error(error: failure)
              )
      );
    }
  }
}