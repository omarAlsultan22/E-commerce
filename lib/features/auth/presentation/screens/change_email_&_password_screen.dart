import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/change_email_and_password_cubit.dart';
import '../widgets/layouts/change_email_&_password_layout.dart';
import '../../../../core/presentation/states/message_state.dart';
import '../../data/repositories_impl/firebase_auth_repository.dart';
import '../../domain/useCases/change_email_and_password_useCase.dart';
import 'package:international_cuisine/core/data/data_sources/remote/firebase_auth.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_provider.dart';
import 'package:international_cuisine/core/data/data_sources/local/shared_preferences.dart';


class ChangeEmailAndPasswordScreen extends StatelessWidget {
  const ChangeEmailAndPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _cacheHelper = CacheHelper();
    final _auth = FirebaseAuthService();
    final _authRepository = FirebaseAuthRepository(authService: _auth);
    final _useCase = ChangeEmailAndPasswordUseCase(
        authRepository: _authRepository);
    final _connectivityProvider = ConnectivityProvider();
    return BlocProvider(create: (context) =>
        ChangeEmailAndPasswordCubit(useCase: _useCase,
            connectivityProvider: _connectivityProvider),
        child: BlocBuilder<ChangeEmailAndPasswordCubit, MessageState>(
            builder: (context, state) {
              final _cubit = ChangeEmailAndPasswordCubit.get(context);
              return ChangeEmailAndPasswordLayout(
                  cacheHelper: _cacheHelper,
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