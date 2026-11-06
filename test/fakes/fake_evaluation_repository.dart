import 'package:international_cuisine/features/evaluation/domain/repositories/evaluation_repositories.dart';


class FakeEvaluationRepository implements EvaluationRepository {
  int sendEvaluationCallCount = 0;
  String? lastDocId;
  String? lastEvaluationValue;
  Object? sendEvaluationError;

  @override
  Future<void> sendEvaluation({
    required String docId,
    required String evaluationValue,
  }) async {
    sendEvaluationCallCount++;
    lastDocId = docId;
    lastEvaluationValue = evaluationValue;
    if (sendEvaluationError != null) throw sendEvaluationError!;
  }
}