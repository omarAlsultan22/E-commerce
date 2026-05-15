import 'package:international_cuisine/core/domain/services/connectivity_service/connectivity_service.dart';
import 'package:international_cuisine/core/errors/exceptions/network_app_exception.dart';
import 'package:international_cuisine/core/presentation/states/message_state.dart';
import 'package:international_cuisine/core/data/models/message_result.dart';
import '../../../../core/errors/mappers/error_handler.dart';
import '../../domain/useCases/evaluation_useCase.dart';
import '../../../../core/constants/app_strings.dart';
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
              error: NetworkAppException(message: AppStrings.noInternetMessage)),
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