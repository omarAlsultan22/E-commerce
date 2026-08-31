import 'package:international_cuisine/core/data/data_sources/local/cache_helper.dart';
import '../../../features/auth/presentation/cubits/change_email_and_password_cubit.dart';
import '../../../features/auth/data/repositories_impl/firebase_sign_up_repository.dart';
import '../../../features/auth/domain/useCases/change_email_and_password_useCase.dart';
import '../../../features/auth/data/repositories_impl/firebase_auth_repository.dart';
import '../../../features/auth/presentation/cubits/forget_password_cubit.dart';
import '../../domain/services/connectivity_service/connectivity_provider.dart';
import 'package:international_cuisine/core/services/session_service.dart';
import '../../../features/auth/presentation/cubits/sign_in_cubit.dart';
import '../../../features/auth/presentation/cubits/sign_up_cubit.dart';
import '../../../features/auth/domain/useCases/sign_in_useCase.dart';
import '../../../features/auth/domain/useCases/sign_up_useCase.dart';
import '../../data/data_sources/remote/firebase_auth.dart';
import '../../data/data_sources/remote/firestore.dart';
import '../service _locator.dart';


class AuthDependencies {
  static void register() {
    // Repository
    sl.registerLazySingleton(() =>
        FirebaseSignUpRepository(
            repository: sl<FirestoreService>()));
    sl.registerLazySingleton(() =>
        FirebaseAuthRepository(authService: sl<FirebaseAuthService>()));

    // UseCase
    sl.registerLazySingleton(() =>
        SignInUseCase(
            authRepository: sl<FirebaseAuthRepository>(),
            sessionService: sl<SessionService>()));
    sl.registerLazySingleton(() =>
        SignUpUseCase(
            authRepository: sl<FirebaseAuthRepository>(),
            signUpRepository: sl<FirebaseSignUpRepository>(),
            cacheHelper: sl<CacheHelper>()));
    sl.registerLazySingleton(() =>
        ChangeEmailAndPasswordUseCase(
            authRepository: sl<FirebaseAuthRepository>()));

    // Cubits
    sl.registerLazySingleton(() =>
        SignInCubit(useCase: sl<SignInUseCase>(),
            connectivityProvider: sl<ConnectivityProvider>()));
    sl.registerLazySingleton(() =>
        SignUpCubit(useCase: sl<SignUpUseCase>(),
            connectivityProvider: sl<ConnectivityProvider>()));
    sl.registerLazySingleton(() =>
        ForgetPasswordCubit(repository: sl<FirebaseAuthRepository>(),
            connectivityProvider: sl<ConnectivityProvider>()));
    sl.registerLazySingleton(() =>
        ChangeEmailAndPasswordCubit(
            useCase: sl<ChangeEmailAndPasswordUseCase>(),
            connectivityProvider: sl<ConnectivityProvider>()));
  }
}