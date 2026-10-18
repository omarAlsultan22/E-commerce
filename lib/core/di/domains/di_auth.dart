import '../../../features/auth/presentation/cubits/change_email_and_password_cubit.dart';
import '../../../features/auth/domain/use_cases/change_email_and_password_use_case.dart';
import '../../../features/auth/data/repositories_impl/sign_up_repository_impl.dart';
import 'package:international_cuisine/core/data/data_sources/local/cache_helper_impl.dart';
import '../../../features/auth/data/repositories_impl/auth_repository_impl.dart';
import '../../../features/auth/presentation/cubits/forget_password_cubit.dart';
import '../../domain/services/connectivity_service/connectivity_provider.dart';
import 'package:international_cuisine/core/services/session_service.dart';
import '../../../features/auth/presentation/cubits/sign_in_cubit.dart';
import '../../../features/auth/presentation/cubits/sign_up_cubit.dart';
import '../../../features/auth/domain/use_cases/sign_in_use_case.dart';
import '../../../features/auth/domain/use_cases/sign_up_use_case.dart';
import '../../data/data_sources/remote/auth_service_impl.dart';
import '../../data/data_sources/remote/firestore_service_impl.dart';
import '../service _locator.dart';


class AuthDependencies {
  static void register() {
    // Repository
    sl.registerLazySingleton(() =>
        SignUpRepositoryImpl(
            dataSource: sl<FirestoreServiceImpl>()));
    sl.registerLazySingleton(() =>
        AuthRepositoryImpl(authService: sl<AuthServiceImpl>()));

    // UseCase
    sl.registerLazySingleton(() =>
        SignInUseCase(
            authRepository: sl<AuthRepositoryImpl>(),
            sessionService: sl<SessionService>()));
    sl.registerLazySingleton(() =>
        SignUpUseCase(
            authRepository: sl<AuthRepositoryImpl>(),
            signUpRepository: sl<SignUpRepositoryImpl>(),
            cacheHelper: sl<CacheHelperImpl>()));
    sl.registerLazySingleton(() =>
        ChangeEmailAndPasswordUseCase(
            authRepository: sl<AuthRepositoryImpl>()));

    // Cubits
    sl.registerLazySingleton(() =>
        SignInCubit(useCase: sl<SignInUseCase>(),
            connectivityProvider: sl<ConnectivityProvider>()));
    sl.registerLazySingleton(() =>
        SignUpCubit(useCase: sl<SignUpUseCase>(),
            connectivityProvider: sl<ConnectivityProvider>()));
    sl.registerLazySingleton(() =>
        ForgetPasswordCubit(repository: sl<AuthRepositoryImpl>(),
            connectivityProvider: sl<ConnectivityProvider>()));
    sl.registerLazySingleton(() =>
        ChangeEmailAndPasswordCubit(
            useCase: sl<ChangeEmailAndPasswordUseCase>(),
            connectivityProvider: sl<ConnectivityProvider>()));
  }
}