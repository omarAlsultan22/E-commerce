import 'package:flutter/material.dart';
import '../../domain/useCases/auth_useCase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/layouts/change_email_&_password_layout.dart';
import '../../data/repositories_impl/firebase_auth_repository.dart';
import '../../../user_info/data/repositories_impl/firestore_user_info_repository.dart';
import 'package:international_cuisine/features/auth/presentation/operations/auth_operations.dart';


class ChangeEmailAndPasswordScreen extends StatelessWidget {
  const ChangeEmailAndPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final authRepository = FirebaseAuthRepository(auth: auth);
    final repository = FirebaseFirestore.instance;
    final userInfoRepository = FirestoreInfoRepository(repository: repository);
    final authUseCase = AuthUseCase(
        authRepository: authRepository, userInfoRepository: userInfoRepository);
    final authOperations = AuthOperations(authUseCase: authUseCase);
    return ChangeEmailAndPasswordLayout(authOperations);
  }
}