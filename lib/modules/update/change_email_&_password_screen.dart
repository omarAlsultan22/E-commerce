import 'package:international_cuisine/modules/update/cubit.dart';
import '../../layout/change_email_&_password_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';


class ChangeEmailAndPasswordScreen extends StatelessWidget {
  const ChangeEmailAndPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppModelCubit(),
      child: const ChangeEmailAndPasswordLayout(),
    );
  }
}