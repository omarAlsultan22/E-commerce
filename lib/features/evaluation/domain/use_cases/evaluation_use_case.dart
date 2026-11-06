import 'package:international_cuisine/core/services/session_service.dart';
import 'package:international_cuisine/features/evaluation/domain/repositories/evaluation_repositories.dart';


class EvaluationUseCase {
  final SessionService _sessionService;
  final EvaluationRepository _repository;

  const EvaluationUseCase({
    required SessionService sessionService,
    required EvaluationRepository repository
  })
      : _repository = repository,
        _sessionService = sessionService;

  Future<void> sendEvaluationExecute({
    required String evaluationText
  }) async {
    await _repository.sendEvaluation(
        evaluationValue: evaluationText,
        docId: _sessionService.currentUid
    );
  }
}