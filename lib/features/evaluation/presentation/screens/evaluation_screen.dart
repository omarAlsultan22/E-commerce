import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/presentation/states/message_state.dart';
import 'package:international_cuisine/core/data/data_sources/remote/firestore.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_provider.dart';
import 'package:international_cuisine/features/evaluation/domain/useCases/evaluation_useCase.dart';
import 'package:international_cuisine/features/evaluation/presentation/cubits/evaluation_cubit.dart';
import 'package:international_cuisine/features/evaluation/presentation/widgets/layouts/evaluation_layout.dart';
import 'package:international_cuisine/features/evaluation/data/repositories_impl/firebase_evaluation_repository.dart';


class EvaluationScreen extends StatelessWidget {
  const EvaluationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _firestore = FirestoreService();
    final _repository = FirebaseEvaluationRepository(firestore: _firestore);
    final _useCase = EvaluationUseCase(repository: _repository);

    final _connectivityProvider = ConnectivityProvider();

    return BlocProvider<EvaluationCubit>(
        create: (context) =>
            EvaluationCubit(
                useCase: _useCase, connectivityProvider: _connectivityProvider
            ),
        child: BlocBuilder<EvaluationCubit, MessageState>(
            builder: (context, state) {
              final _cubit = EvaluationCubit.get(context);
              return EvaluationLayout(
                onUpdate: (evaluationText) =>
                    _cubit.sendEvaluation(evaluationText: evaluationText
                    ), messageResult: state.messageResult!,
              );
            }
        )
    );
  }
}
