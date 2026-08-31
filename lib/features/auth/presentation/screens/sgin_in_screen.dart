import 'package:international_cuisine/core/services/session_service.dart';
import '../../../../core/presentation/states/message_state.dart';
import '../../../../core/di/service _locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/layouts/sign_in_layout.dart';
import 'package:flutter/material.dart';
import '../cubits/sign_in_cubit.dart';


class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) =>
        sl<SignInCubit>(),
        child: BlocBuilder<SignInCubit, MessageState>(
            builder: (context, state) {
              final _cubit = SignInCubit.get(context);
              return SignInLayout(
                  messageResult: state.messageResult!,
                  sessionService: sl<SessionService>(),
                  onUpdate: ({
                    required String userEmail,
                    required String userPassword
                  }) =>
                      _cubit.signIn(
                          userEmail: userEmail,
                          userPassword: userPassword
                      )
              );
            }
        )
    );
  }
}