abstract class EvaluationRepository {
  Future<void> sendEvaluation({
    required String evaluationValue
  });
}