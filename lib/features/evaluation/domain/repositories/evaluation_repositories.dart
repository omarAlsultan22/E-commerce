abstract class EvaluationRepository {
  Future<void> sendEvaluation({
    required String evaluationText
  });
}