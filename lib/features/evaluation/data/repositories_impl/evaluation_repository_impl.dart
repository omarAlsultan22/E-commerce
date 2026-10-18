import '../../domain/repositories/evaluation_repositories.dart';
import '../../../../core/domain/data_sources/remote/firestore_service.dart';
import 'package:international_cuisine/core/errors/exceptions/evaluation_exception.dart';


class EvaluationRepositoryImpl implements EvaluationRepository {
  final FirestoreService _dataSource;

  EvaluationRepositoryImpl({required FirestoreService dataSource})
      : _dataSource = dataSource;

  static const String evaluationId = 'evaluation';
  static const String evaluationKey = 'evaluationText';

  @override
  Future<void> sendEvaluation({required String evaluationValue}) async {
    try {
      await _dataSource.setData(
          collectionPath: evaluationId,
          docId: '',
          data: {
            evaluationKey: evaluationValue
          }
      );
    }
    catch (e) {
      throw EvaluationException(message: 'Sent failed ${e.toString()}');
    }
  }
}

