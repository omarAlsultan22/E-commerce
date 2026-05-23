import '../../../../core/domain/services/connectivity_service/connectivity_service.dart';
import '../../../../core/data/data_sources/remote/firebase_auth.dart';
import '../../data/repositories_impl/firebase_auth_repository.dart';
import '../../../../core/presentation/states/message_state.dart';
import '../widgets/layouts/forget_password_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/forget_password_cubit.dart';
import 'package:flutter/material.dart';


class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuthService();
    final authRepository = FirebaseAuthRepository(authService: auth);
    final connectivityService = ConnectivityService();
    final cubit = ForgetPasswordCubit(
        repository: authRepository, connectivityService: connectivityService);
    return BlocBuilder<ForgetPasswordCubit, MessageState>(
        builder: (context, state) {
          return ForgetPasswordLayout(
              messageResult: state.messageResult!,
              onUpdate: ({
                required String userEmail,
              }) =>
                  cubit.sendResetEmail(
                      userEmail: userEmail
                  )
          );
        }
    );
  }
}
