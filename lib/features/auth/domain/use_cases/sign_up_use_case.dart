import '../repositories/auth_repository.dart';
import '../repositories/sign_up_repository.dart';
import '../../../../core/data/models/user_model.dart';
import '../../../../core/data/data_sources/local/cache_helper_impl.dart';


class SignUpUseCase {
  final CacheHelperImpl _cacheHelper;
  final AuthRepository _authRepository;
  final SignUpRepository _signUpRepository;

  SignUpUseCase({
    required CacheHelperImpl cacheHelper,
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

    await _cacheHelper.setString(
        key: 'userName', value: firstName + lastName);
  }
}

