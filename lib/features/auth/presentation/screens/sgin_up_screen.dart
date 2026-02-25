import 'package:international_cuisine/features/auth/presentation/operations/auth_operations.dart';
import '../../../user_info/data/repositories_impl/firestore_user_info_repository.dart';
import '../../data/repositories_impl/firebase_auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/useCases/auth_useCase.dart';
import '../widgets/layouts/sign_up_layout.dart';
import 'package:flutter/material.dart';


class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final authRepository = FirebaseAuthRepository(auth: auth);
    final repository = FirebaseFirestore.instance;
    final userInfoRepository = FirestoreInfoRepository(repository: repository);
    final authUseCase = AuthUseCase(
        authRepository: authRepository, userInfoRepository: userInfoRepository);
    final authOperations = AuthOperations(authUseCase: authUseCase);
    return SignUpLayout(authOperations);
  }
}