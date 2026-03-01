import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/evaluation_repositories.dart';


class FirebaseEvaluationRepository implements EvaluationRepository {
  final FirebaseFirestore _firestore;

  FirebaseEvaluationRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  static const String evaluationId = 'evaluation';
  static const String evaluationKey = 'evaluationText';

  @override
  Future<void> sendEvaluation({required String evaluationValue}) async {
    try {
      await _firestore.collection(evaluationId).doc().set({
        evaluationKey: evaluationValue
      });
    }
    catch (e) {
      throw Exception('Sent failed ${e.toString()}');
    }
  }
}

