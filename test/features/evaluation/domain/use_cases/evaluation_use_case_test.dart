import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../fakes/mock_session_service.dart';
import '../../../../fakes/fake_evaluation_repository.dart';
import 'package:international_cuisine/features/evaluation/domain/use_cases/evaluation_use_case.dart';


void main() {
  late FakeEvaluationRepository fakeRepo;
  late MockSessionService mockSession;
  late EvaluationUseCase useCase;

  setUp(() {
    fakeRepo = FakeEvaluationRepository();
    mockSession = MockSessionService();
    when(() => mockSession.currentUid).thenReturn('uid-123');
    useCase = EvaluationUseCase(
      repository: fakeRepo,
      sessionService: mockSession,
    );
  });

  group('sendEvaluationExecute', () {
    test('passes evaluationText and currentUid to repository', () async {
      await useCase.sendEvaluationExecute(evaluationText: 'Great app!');

      expect(fakeRepo.sendEvaluationCallCount, 1);
      expect(fakeRepo.lastDocId, 'uid-123');
      expect(fakeRepo.lastEvaluationValue, 'Great app!');
    });

    test('uses currentUid from SessionService', () async {
      when(() => mockSession.currentUid).thenReturn('custom-uid-456');

      await useCase.sendEvaluationExecute(evaluationText: 'Nice');

      expect(fakeRepo.lastDocId, 'custom-uid-456');
    });

    test('passes empty uid when currentUid is empty', () async {
      when(() => mockSession.currentUid).thenReturn('');

      await useCase.sendEvaluationExecute(evaluationText: 'Great');

      expect(fakeRepo.lastDocId, '');
    });

    test('propagates errors from repository', () async {
      fakeRepo.sendEvaluationError = Exception('send failed');

      expect(
            () => useCase.sendEvaluationExecute(evaluationText: 'Great'),
        throwsA(isA<Exception>()),
      );
    });
  });
}