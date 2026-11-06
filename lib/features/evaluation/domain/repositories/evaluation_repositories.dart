abstract class EvaluationRepository {
  Future<void> sendEvaluation({
    required String docId,
    required String evaluationValue
  });
}