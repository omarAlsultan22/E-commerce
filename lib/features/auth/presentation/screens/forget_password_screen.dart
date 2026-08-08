import '../../../../core/presentation/states/message_state.dart';
import '../widgets/layouts/forget_password_layout.dart';
import '../../../../core/di/service _locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/forget_password_cubit.dart';
import 'package:flutter/material.dart';


class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) =>
        sl<ForgetPasswordCubit>(),
        child: BlocBuilder<ForgetPasswordCubit, MessageState>(
            builder: (context, state) {
              final _cubit = ForgetPasswordCubit.get(context);
              return ForgetPasswordLayout(
                  messageResult: state.messageResult!,
                  onUpdate: ({
                    required String userEmail,
                  }) =>
                      _cubit.sendResetEmail(
                          userEmail: userEmail
                      )
              );
            }
        )
    );
  }
}
