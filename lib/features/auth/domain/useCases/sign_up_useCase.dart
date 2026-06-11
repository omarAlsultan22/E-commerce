import '../repositories/auth_repository.dart';
import '../repositories/sign_up_repository.dart';
import '../../../../core/data/models/user_model.dart';
import '../../../../core/data/data_sources/local/shared_preferences.dart';


class SignUpUseCase {
  final CacheHelper _cacheHelper;
  final AuthRepository _authRepository;
  final SignUpRepository _signUpRepository;

  SignUpUseCase({
    required CacheHelper cacheHelper,
    required AuthRepository authRepository,
    required SignUpRepository signUpRepository
  })
      : _cacheHelper = cacheHelper,
        _authRepository = authRepository,
        _signUpRepository = signUpRepository;

  Future<void> signUpExecute({
    required String firstName,
    required String lastName,
    required String userEmail,
    required String userPassword,
    required String userPhone,
    required String userLocation,
  }) async {
    try {
      final userCredential = await _authRepository.signUp(
        email: userEmail,
        password: userPassword,
      );

      UserModel userModel = UserModel(
        firstName: firstName,
        lastName: lastName,
        userPhone: userPhone,
        userLocation: userLocation,
      );

      await _signUpRepository.createUserInfo(
          userModel: userModel, userCredential: userCredential);

      await _cacheHelper.setStringValue(
          key: 'userName', value: firstName + lastName);
    } catch (e) {
      rethrow;
    }
  }
}

