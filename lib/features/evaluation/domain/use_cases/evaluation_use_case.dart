import 'package:international_cuisine/features/evaluation/domain/repositories/evaluation_repositories.dart';


class EvaluationUseCase {
  EvaluationRepository _repository;

  EvaluationUseCase({
    required EvaluationRepository repository
  })
      : _repository = repository;

  Future<void> sendEvaluationExecute({
    required String evaluationText
  }) async {
    await _repository.sendEvaluation(evaluationValue: evaluationText);
  }
}