import 'package:international_cuisine/core/domain/services/connectivity_service/connectivity_service.dart';
import 'package:international_cuisine/core/errors/exceptions/network_app_exception.dart';
import 'package:international_cuisine/core/presentation/states/message_state.dart';
import 'package:international_cuisine/core/data/models/message_result.dart';
import '../../../../core/presentation/mixins/error_handler_mixin.dart';
import '../../domain/useCases/evaluation_useCase.dart';
import '../../../../core/constants/app_strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class EvaluationCubit extends Cubit<MessageState> with ErrorHandlerMixin<MessageState> {
  final EvaluationUseCase _useCase;
  final ConnectivityService _connectivityService;

  EvaluationCubit({
    required EvaluationUseCase useCase,
    required ConnectivityService connectivityService
  })
      : _useCase = useCase,
        _connectivityService = connectivityService,
        super(MessageState.initial());

  static EvaluationCubit get(context) => BlocProvider.of(context);

  Future<void> sendEvaluation({
    required String evaluationText
  }) async {
    final _isConnected = await _connectivityService.checkInternetConnection();
    if (!_isConnected) {
      emit(
        MessageState(
          messageResult: MessageResult.error(
              error: NetworkAppException(
                  message: AppStrings.noInternetMessage)),
        ),
      );
      return;
    }
    emit(MessageState(
        messageResult: MessageResult.loading()));
    try {
      await _useCase.sendEvaluationExecute(evaluationText: evaluationText);
      emit(
          MessageState(
              messageResult: MessageResult.success()
          )
      );
    } catch (e, stackTrace) {
      handleError(
          error: e,
          stackTrace: stackTrace,
          onError: (failure) =>
              MessageState(
                  messageResult: MessageResult.error(
                      error: failure
                  )
              )
      );
    }
  }
}