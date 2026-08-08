import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service _locator.dart';
import '../../../../core/presentation/states/message_state.dart';
import 'package:international_cuisine/features/evaluation/presentation/cubits/evaluation_cubit.dart';
import 'package:international_cuisine/features/evaluation/presentation/widgets/layouts/evaluation_layout.dart';


class EvaluationScreen extends StatelessWidget {
  const EvaluationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EvaluationCubit>(
        create: (context) =>
            sl<EvaluationCubit>(),
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
