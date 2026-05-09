import 'package:flutter/cupertino.dart';
import 'package:international_cuisine/core/data/data_sources/remote/firestore.dart';
import 'package:international_cuisine/features/evaluation/domain/useCases/evaluation_useCase.dart';
import 'package:international_cuisine/features/evaluation/presentation/cubits/evaluation_cubit.dart';
import 'package:international_cuisine/core/domain/services/connectivity_service/connectivity_service.dart';
import 'package:international_cuisine/features/evaluation/presentation/widgets/layouts/evaluation_layout.dart';
import 'package:international_cuisine/features/evaluation/data/repositories_impl/firebase_evaluation_repository.dart';


class EvaluationScreen extends StatelessWidget {
  const EvaluationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _firestore = FirestoreService();
    final _repository = FirebaseEvaluationRepository(firestore: _firestore);
    final _useCase = EvaluationUseCase(repository: _repository);
    final _connectivityProvider = ConnectivityService();
    final _cubit = EvaluationCubit(
        useCase: _useCase, connectivityService: _connectivityProvider);
    return EvaluationLayout(onUpdate: (evaluationText) =>
        _cubit.sendEvaluation(evaluationText: evaluationText)
    );
  }
}
