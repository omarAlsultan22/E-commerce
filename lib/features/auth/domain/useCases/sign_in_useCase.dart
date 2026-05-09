import '../repositories/auth_repository.dart';
import '../../../../core/constants/app_keys.dart';
import '../../../../core/data/data_sources/local/shared_preferences.dart';


class SignInUseCase {
  final CacheHelper _cacheHelper;
  final AuthRepository _authRepository;

  SignInUseCase({
    required CacheHelper cacheHelper,
    required AuthRepository authRepository,
  })
      : _cacheHelper = cacheHelper,
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
      _cacheHelper.setStringValue(
          key: AppKeys.uId, value: userCredential.user!.uid);
    } catch (e) {
      rethrow;
    }
  }
}

