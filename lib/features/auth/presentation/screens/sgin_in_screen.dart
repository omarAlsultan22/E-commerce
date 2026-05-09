import 'package:international_cuisine/features/auth/data/repositories_impl/firebase_auth_repository.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_service.dart';
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
    final _connectivityService = ConnectivityService();
    final _cubit = SignInCubit(
        useCase: _useCase, connectivityService: _connectivityService);
    return BlocBuilder<SignInCubit, AuthState>(
        builder: (context, state) {
          return SignInLayout(
              cacheHelper: _cacheHelper,
              messageResult: state.messageResult!,
              onUpdate: ({
                required String userEmail,
                required String userPassword
              }) =>
                  _cubit.signIn(
                      userEmail: userEmail, userPassword: userPassword
                  )
          );
        }
    );
  }
}