import '../../../../core/domain/services/connectivity_service/connectivity_service.dart';
import 'package:international_cuisine/core/data/data_sources/remote/firestore.dart';
import '../../../../core/data/data_sources/local/shared_preferences.dart';
import '../../data/repositories_impl/firebase_sign_up_repository.dart';
import '../../../../core/data/data_sources/remote/firebase_auth.dart';
import '../../data/repositories_impl/firebase_auth_repository.dart';
import '../../../../core/presentation/states/message_state.dart';
import '../../domain/useCases/sign_up_useCase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/layouts/sign_up_layout.dart';
import 'package:flutter/material.dart';
import '../cubits/sign_up_cubit.dart';


class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _cacheHelper = CacheHelper();
    final _authService = FirebaseAuthService();
    final _repository = FirestoreService();
    final _authRepository = FirebaseAuthRepository(authService: _authService);
    final _signUpRepository = FirebaseSignUpRepository(
        repository: _repository);
    final _useCase = SignUpUseCase(
        authRepository: _authRepository,
        signUpRepository: _signUpRepository,
        cacheHelper: _cacheHelper);
    final _connectivityService = ConnectivityService();
    final _cubit = SignUpCubit(
        useCase: _useCase, connectivityService: _connectivityService);
    return BlocBuilder<SignUpCubit, MessageState>(
        builder: (context, state) {
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
    );
  }
}