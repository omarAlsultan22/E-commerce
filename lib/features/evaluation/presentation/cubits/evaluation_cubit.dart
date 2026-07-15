import '../../../../core/domain/services/connectivity_service/connectivity_provider.dart';
import 'package:international_cuisine/core/presentation/states/message_state.dart';
import 'package:international_cuisine/core/data/models/message_result.dart';
import '../../../../core/presentation/mixins/error_handler_mixin.dart';
import '../../domain/useCases/evaluation_useCase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';


class EvaluationCubit extends Cubit<MessageState> with ErrorHandlerMixin<MessageState> {
  final EvaluationUseCase _useCase;
  final ConnectivityProvider _connectivityProvider;

  EvaluationCubit({
    required EvaluationUseCase useCase,
    required ConnectivityProvider connectivityProvider
  })
      : _useCase = useCase,
        _connectivityProvider = connectivityProvider,
        super(MessageState.initial()
      );

  static EvaluationCubit get(context) => BlocProvider.of(context);

  Future<void> sendEvaluation({
    required String evaluationText
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
      await _useCase.sendEvaluationExecute(evaluationText: evaluationText);
      emit(
          MessageState(
              messageResult: MessageResult.success(message: 'تم الارسال بنجاح')
          )
      );
    } catch (e, stackTrace) {
      handleError(
          error: e,
          stackTrace: stackTrace,
          onError: (failure) =>
              MessageState(
                  messageResult: MessageResult.error(
                      error: failure, message: 'فشل الارسال: '
                  )
              )
      );
    }
  }
}