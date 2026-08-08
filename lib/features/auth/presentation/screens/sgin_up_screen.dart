import '../../../../core/presentation/states/message_state.dart';
import '../../../../core/di/service _locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/layouts/sign_up_layout.dart';
import 'package:flutter/material.dart';
import '../cubits/sign_up_cubit.dart';


class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) =>
        sl<SignUpCubit>(),
        child: BlocBuilder<SignUpCubit, MessageState>(
            builder: (context, state) {
              final _cubit = SignUpCubit.get(context);
              return SignUpLayout(
                  messageResult: state.messageResult!,
                  onUpdate: ({
                    required String firstName,
                    required String lastName,
                    required String userEmail,
                    required String userPassword,
                    required String userPhone,
                    required String userLocation
                  }) =>
                      _cubit.signUp(
                          firstName: firstName,
                          lastName: lastName,
                          userEmail: userEmail,
                          userPassword: userPassword,
                          userPhone: userPhone,
                          userLocation: userLocation
                      )
              );
            }
        )
    );
  }
}