import '../repositories/auth_repository.dart';
import 'package:international_cuisine/core/services/session_service.dart';


class SignOutUseCase {
  final SessionService _sessionService;
  final AuthRepository _authRepository;

  SignOutUseCase({
    required SessionService sessionService,
    required AuthRepository authRepository,
  })
      : _sessionService = sessionService,
        _authRepository = authRepository;

  Future<void> signOutExecute() async {
    try {
      await _sessionService.logout();
      await _authRepository.signOut();
    } catch (e) {
      rethrow;
    }
  }
}

