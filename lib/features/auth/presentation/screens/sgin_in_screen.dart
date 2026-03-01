import 'package:international_cuisine/features/auth/data/repositories_impl/firebase_auth_repository.dart';
import 'package:international_cuisine/features/auth/presentation/operations/auth_operations.dart';
import '../../../user_info/data/repositories_impl/firestore_user_info_repository.dart';
import 'package:international_cuisine/features/auth/domain/useCases/auth_useCase.dart';
import '../../../../core/presentation/screens/connectivity_aware_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/layouts/sign_in_layout.dart';
import 'package:flutter/material.dart';


class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final authRepository = FirebaseAuthRepository(auth: auth);
    final repository = FirebaseFirestore.instance;
    final userInfoRepository = FirestoreInfoRepository(repository: repository);
    final authUseCase = AuthUseCase(
        authRepository: authRepository, userInfoRepository: userInfoRepository);
    final authOperations = AuthOperations(authUseCase: authUseCase);
    return ConnectivityAwareService(
        child: SignInLayout(authOperations)
    );
  }
}