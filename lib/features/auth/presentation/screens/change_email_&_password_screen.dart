import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service _locator.dart';
import '../cubits/change_email_and_password_cubit.dart';
import '../widgets/layouts/change_email_&_password_layout.dart';
import '../../../../core/presentation/states/message_state.dart';
import 'package:international_cuisine/core/data/data_sources/local/cache_helper.dart';


class ChangeEmailAndPasswordScreen extends StatelessWidget {
  const ChangeEmailAndPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) =>
        sl<ChangeEmailAndPasswordCubit>(),
        child: BlocBuilder<ChangeEmailAndPasswordCubit, MessageState>(
            builder: (context, state) {
              final _cubit = ChangeEmailAndPasswordCubit.get(context);
              return ChangeEmailAndPasswordLayout(
                  cacheHelper: sl<CacheHelper>(),
                  messageResult: state.messageResult!,
                  onUpdate: ({
                    required String newEmail,
                    required String currentPassword,
                    required String newPassword
                  }) =>
                      _cubit.changeEmailAndPassword(
                          newEmail: newEmail,
                          currentPassword: currentPassword,
                          newPassword: newPassword
                      )
              );
            }
        )
    );
  }
}