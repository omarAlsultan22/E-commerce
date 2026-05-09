import '../../../../core/data/data_sources/remote/firestore.dart';
import '../../domain/repositories/evaluation_repositories.dart';


class FirebaseEvaluationRepository implements EvaluationRepository {
  final FirestoreService _firestore;

  FirebaseEvaluationRepository({required FirestoreService firestore})
      : _firestore = firestore;

  static const String evaluationId = 'evaluation';
  static const String evaluationKey = 'evaluationText';

  @override
  Future<void> sendEvaluation({required String evaluationValue}) async {
    try {
      await _firestore.setData(
          collectionPath: evaluationId,
          docId: '',
          data: {
            evaluationKey: evaluationValue
          }
      );
    }
    catch (e) {
      throw Exception('Sent failed ${e.toString()}');
    }
  }
}

