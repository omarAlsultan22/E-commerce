import 'package:international_cuisine/features/auth/data/repositories_impl/firebase_auth_repository.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_provider.dart';
import '../../../../core/data/data_sources/local/shared_preferences.dart';
import '../../../../core/data/data_sources/remote/firebase_auth.dart';
import '../../../../core/presentation/states/message_state.dart';
import '../../domain/useCases/sign_in_useCase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/layouts/sign_in_layout.dart';
import 'package:flutter/material.dart';
import '../cubits/sign_in_cubit.dart';


class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _cacheHelper = CacheHelper();
    final _auth = FirebaseAuthService();
    final _authRepository = FirebaseAuthRepository(authService: _auth);
    final _useCase = SignInUseCase(
        authRepository: _authRepository, cacheHelper: _cacheHelper);
    final _connectivityProvider = ConnectivityProvider();
    return BlocProvider(create: (context) =>
        SignInCubit(useCase: _useCase,
            connectivityProvider: _connectivityProvider),
        child: BlocBuilder<SignInCubit, MessageState>(
            builder: (context, state) {
              final _cubit = SignInCubit.get(context);
              return SignInLayout(
                  cacheHelper: _cacheHelper,
                  messageResult: state.messageResult!,
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