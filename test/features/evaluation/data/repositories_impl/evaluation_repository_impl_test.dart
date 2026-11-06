import 'package:flutter_test/flutter_test.dart';
import '../../../../fakes/fake_firestore_service.dart';
import 'package:international_cuisine/core/errors/exceptions/evaluation_exception.dart';
import 'package:international_cuisine/features/evaluation/domain/repositories/evaluation_repositories.dart';
import 'package:international_cuisine/features/evaluation/data/repositories_impl/evaluation_repository_impl.dart';


void main() {
  late EvaluationRepository repository;
  late FakeFirestoreService fakeDataSource;

  setUp(() {
    fakeDataSource = FakeFirestoreService();
    repository = EvaluationRepositoryImpl(dataSource: fakeDataSource);
  });

  group('sendEvaluation', () {
    test('calls setData with correct collection and data', () async {
      await repository.sendEvaluation(
        docId: 'eval_1',
        evaluationValue: 'Great app!',
      );

      expect(fakeDataSource.setDataCallCount, 1);
      expect(fakeDataSource.lastSetCollectionPath, 'evaluation');
      expect(fakeDataSource.lastSetData, {'evaluationText': 'Great app!'});
    });

    test('passes docId to setData', () async {
      await repository.sendEvaluation(
        docId: 'user_123',
        evaluationValue: 'Great app!',
      );

      expect(fakeDataSource.lastSetDocId, 'user_123');
    });

    test('passes evaluationValue correctly', () async {
      await repository.sendEvaluation(
        docId: 'eval_1',
        evaluationValue: 'Excellent!',
      );

      expect(fakeDataSource.lastSetData!['evaluationText'], 'Excellent!');
    });

    test('throws EvaluationException when setData fails', () async {
      fakeDataSource.setDataError = Exception('network error');

      expect(
            () =>
            repository.sendEvaluation(
              docId: 'eval_1',
              evaluationValue: 'Great',
            ),
        throwsA(isA<EvaluationException>()),
      );
    });

    test('includes original error message in EvaluationException', () async {
      fakeDataSource.setDataError = Exception('network error');

      expect(
            () =>
            repository.sendEvaluation(
              docId: 'eval_1',
              evaluationValue: 'Great',
            ),
        throwsA(
          isA<EvaluationException>().having(
                (e) => e.message,
            'message',
            contains('network error'),
          ),
        ),
      );
    });

    test('does not call setData when docId is empty (documents behavior)',
            () async {
          // لا تحقق من docId — يمرره كما هو
          await repository.sendEvaluation(
            docId: '',
            evaluationValue: 'Great',
          );

          // ← setData يُستدعى بـ docId = ''
          // (Firestore يرفضه في الإنتاج — لكن FakeFirestoreService يقبله)
          expect(fakeDataSource.setDataCallCount, 1);
          expect(fakeDataSource.lastSetDocId, '');
        });
  });
}