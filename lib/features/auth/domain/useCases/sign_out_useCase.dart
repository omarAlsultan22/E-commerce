import '../repositories/auth_repository.dart';
import '../../../../core/constants/app_keys.dart';
import '../../../../core/data/data_sources/local/shared_preferences.dart';


class SignOutUseCase {
  final CacheHelper _cacheHelper;
  final AuthRepository _authRepository;

  SignOutUseCase({
    required CacheHelper cacheHelper,
    required AuthRepository authRepository,
  })
      : _cacheHelper = cacheHelper,
        _authRepository = authRepository;

  Future<void> signOutExecute() async {
    try {
      await _cacheHelper.removeValue(key: AppKeys.uId);
      await _authRepository.signOut();
    } catch (e) {
      rethrow;
    }
  }
}

