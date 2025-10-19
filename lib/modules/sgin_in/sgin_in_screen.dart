import 'package:international_cuisine/modules/sgin_in/cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/sign_in_layout.dart';
import 'package:flutter/material.dart';


class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: const SignInLayout(),
    );
  }
}