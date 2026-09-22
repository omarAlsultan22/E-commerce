import '../repositories/auth_repository.dart';


class ChangeEmailAndPasswordUseCase {
  final AuthRepository _authRepository;

  ChangeEmailAndPasswordUseCase({
    required AuthRepository authRepository,
  })
      :
        _authRepository = authRepository;

  Future<void> updateProfileExecute({
    required String newEmail,
    required String newPassword,
    required String currentPassword
  }) async {
    try {
      await _authRepository.updateProfile(
          newEmail: newEmail,
          newPassword: newPassword,
          currentPassword: currentPassword
      );
    } catch (e) {
      rethrow;
    }
  }
}

