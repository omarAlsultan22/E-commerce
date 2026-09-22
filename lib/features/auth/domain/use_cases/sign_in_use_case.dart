import '../repositories/auth_repository.dart';
import 'package:international_cuisine/core/services/session_service.dart';


class SignInUseCase {
  final SessionService _sessionService;
  final AuthRepository _authRepository;

  SignInUseCase({
    required SessionService sessionService,
    required AuthRepository authRepository
  })
      : _sessionService = sessionService,
        _authRepository = authRepository;

  Future<void> signInExecute({
    required String userEmail,
    required String userPassword,
  }) async {
    try {
      final userCredential = await _authRepository.signIn(
          email: userEmail,
          password: userPassword
      );
      _sessionService.login(
          userCredential.user!.uid);
    } catch (e) {
      rethrow;
    }
  }
}

