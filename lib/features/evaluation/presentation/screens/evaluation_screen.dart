import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:international_cuisine/features/evaluation/domain/useCases/evaluation_useCase.dart';
import 'package:international_cuisine/features/evaluation/presentation/operations/evaluation_operations.dart';
import 'package:international_cuisine/features/evaluation/presentation/widgets/layouts/evaluation_layout.dart';
import 'package:international_cuisine/features/evaluation/data/repositories_impl/firebase_evaluation_repository.dart';


class EvaluationScreen extends StatelessWidget {
  const EvaluationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _firestore = FirebaseFirestore.instance;
    final _repository = FirebaseEvaluationRepository(firestore: _firestore);
    final _useCase = EvaluationUseCase(repository: _repository);
    final _operations = EvaluationOperations(useCase: _useCase);
    return EvaluationLayout(_operations);
  }
}
