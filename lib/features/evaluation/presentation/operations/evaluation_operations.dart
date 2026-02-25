import '../../domain/useCases/evaluation_useCase.dart';
import 'package:international_cuisine/core/data/models/message_result_model.dart';


class EvaluationOperations {
  final EvaluationUseCase _useCase;

  EvaluationOperations({
    required EvaluationUseCase useCase
  })
      : _useCase = useCase;

  Future<MessageResultModel> sendEvaluation(
      {required String evaluationText}) async {
    try {
      await _useCase.sendEvaluationExecute(evaluationText: evaluationText);
      return MessageResultModel(isSuccess: true);
    }
    catch (e) {
      return MessageResultModel(isSuccess: false, error: e.toString());
    }
  }
}