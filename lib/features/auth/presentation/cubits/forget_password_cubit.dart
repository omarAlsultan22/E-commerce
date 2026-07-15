import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/data/models/message_result.dart';
import '../../../../core/presentation/states/message_state.dart';
import '../../../../core/presentation/mixins/error_handler_mixin.dart';
import '../../../../core/errors/exceptions/security_app_exception.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_provider.dart';


class ForgetPasswordCubit extends Cubit<MessageState> with ErrorHandlerMixin<MessageState> {
  final AuthRepository _repository;
  final ConnectivityProvider _connectivityProvider;

  ForgetPasswordCubit({
    required AuthRepository repository,
    required ConnectivityProvider connectivityProvider
  })
      : _repository = repository,
        _connectivityProvider = connectivityProvider,
        super(MessageState.initial());

  static ForgetPasswordCubit get(context) => BlocProvider.of(context);

  Future<void> sendResetEmail({
    required String userEmail
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
      if (userEmail.isEmpty) {
        emit(
            MessageState(
              messageResult: MessageResult.error(
                  error: SecurityAppException(
                      message: 'الرجاء إدخال بريدك الإلكتروني')),
            )
        );
      }
      _repository.sendResetEmail(
        userEmail: userEmail,
      );
      emit(MessageState(
          messageResult: MessageResult.success(
              message: 'تم إرسال رابط إعادة التعيين إلى بريدك الإلكتروني')));
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