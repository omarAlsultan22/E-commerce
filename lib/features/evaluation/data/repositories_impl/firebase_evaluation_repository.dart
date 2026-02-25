import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/evaluation_repositories.dart';


class FirebaseEvaluationRepository implements EvaluationRepository {
  final FirebaseFirestore _firestore;

  FirebaseEvaluationRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
  Future<void> sendEvaluation({required String evaluationText}) async {
    try {
      await _firestore.collection('evaluation').doc().set({
        'evaluationText': evaluationText
      });
    }
    catch (e) {
      throw Exception('Sent failed ${e.toString()}');
    }
  }
}

