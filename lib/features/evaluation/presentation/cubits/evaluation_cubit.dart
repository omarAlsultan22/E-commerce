import 'package:international_cuisine/core/domain/services/connectivity_service/connectivity_service.dart';
import 'package:international_cuisine/core/errors/exceptions/network_exception.dart';
import 'package:international_cuisine/core/presentation/states/message_state.dart';
import 'package:international_cuisine/core/data/models/message_result.dart';
import '../../../../core/errors/exceptions/base/app_exception.dart';
import '../../domain/useCases/evaluation_useCase.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/constants/app_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class EvaluationCubit extends Cubit<AuthState> {
  final EvaluationUseCase _useCase;
  final ConnectivityService _connectivityService;

  EvaluationCubit({
    required EvaluationUseCase useCase,
    required ConnectivityService connectivityService
  })
      : _useCase = useCase,
        _connectivityService = connectivityService,
        super(const AuthState());

  static EvaluationCubit get(context) => BlocProvider.of(context);

  Future<void> sendEvaluation({
    required String evaluationText
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
    emit(AuthState(
        messageResult: MessageResult.loading()));
    try {
      await _useCase.sendEvaluationExecute(evaluationText: evaluationText);
      emit(
          AuthState(
              messageResult: MessageResult.success()
          )
      );
    } on AppException catch (e) {
      final exception = ErrorHandler.handleException(e);
      emit(AuthState(messageResult: MessageResult.error(
          error: exception)));
    }
  }
}