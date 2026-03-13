import 'package:flutter/material.dart';
import '../../domain/useCases/auth_useCase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/layouts/change_email_&_password_layout.dart';
import '../../data/repositories_impl/firebase_auth_repository.dart';
import '../../../../core/presentation/screens/connectivity_aware_screen.dart';
import '../../../user_info/data/repositories_impl/firestore_user_info_repository.dart';
import 'package:international_cuisine/features/auth/presentation/services/auth_services.dart';


class ChangeEmailAndPasswordScreen extends StatelessWidget {
  const ChangeEmailAndPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    final _authRepository = FirebaseAuthRepository(auth: _auth);
    final _repository = FirebaseFirestore.instance;
    final _userInfoRepository = FirestoreUserInfoRepository(repository: _repository);
    final _authUseCase = AuthUseCase(
        authRepository: _authRepository, userInfoRepository: _userInfoRepository);
    final _authServices = AuthServices(authUseCase: _authUseCase);
    return ConnectivityAwareService(
        child: ChangeEmailAndPasswordLayout(_authServices)
    );
  }
}