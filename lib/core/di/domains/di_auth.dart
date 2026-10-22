import '../../../features/auth/presentation/cubits/change_email_and_password_cubit.dart';
import '../../../features/auth/domain/use_cases/change_email_and_password_use_case.dart';
import '../../../features/auth/data/repositories_impl/sign_up_repository_impl.dart';
import '../../../features/auth/data/repositories_impl/auth_repository_impl.dart';
import '../../../features/auth/presentation/cubits/forget_password_cubit.dart';
import '../../../features/auth/domain/repositories/sign_up_repository.dart';
import 'package:international_cuisine/core/services/session_service.dart';
import '../../../features/auth/domain/repositories/auth_repository.dart';
import '../../../features/auth/presentation/cubits/sign_in_cubit.dart';
import '../../../features/auth/presentation/cubits/sign_up_cubit.dart';
import '../../../features/auth/domain/use_cases/sign_in_use_case.dart';
import '../../../features/auth/domain/use_cases/sign_up_use_case.dart';
import '../../domain/data_sources/remote/firestore_service.dart';
import '../../domain/data_sources/local/cache_helper.dart';
import '../../domain/data_sources/remote/auth_service.dart';
import '../../providers/connectivity_provider.dart';
import '../service _locator.dart';


class AuthDependencies {
  static void register() {
    // Repository
    sl.registerLazySingleton<SignUpRepository>(() =>
        SignUpRepositoryImpl(
            service: sl<FirestoreService>()));
    sl.registerLazySingleton<AuthRepository>(() =>
        AuthRepositoryImpl(service: sl<AuthService>()));

    // UseCase
    sl.registerLazySingleton<SignInUseCase>(() =>
        SignInUseCase(
            authRepository: sl<AuthRepository>(),
            sessionService: sl<SessionService>()));
    sl.registerLazySingleton<SignUpUseCase>(() =>
        SignUpUseCase(
            authRepository: sl<AuthRepository>(),
            signUpRepository: sl<SignUpRepository>(),
            cacheHelper: sl<CacheHelper>()));
    sl.registerLazySingleton<ChangeEmailAndPasswordUseCase>(() =>
        ChangeEmailAndPasswordUseCase(
            authRepository: sl<AuthRepository>()));

    // Cubits
    sl.registerLazySingleton<SignInCubit>(() =>
        SignInCubit(useCase: sl<SignInUseCase>(),
            connectivityProvider: sl<ConnectivityProvider>()));
    sl.registerLazySingleton<SignUpCubit>(() =>
        SignUpCubit(useCase: sl<SignUpUseCase>(),
            connectivityProvider: sl<ConnectivityProvider>()));
    sl.registerLazySingleton<ForgetPasswordCubit>(() =>
        ForgetPasswordCubit(repository: sl<AuthRepository>(),
            connectivityProvider: sl<ConnectivityProvider>()));
    sl.registerLazySingleton<ChangeEmailAndPasswordCubit>(() =>
        ChangeEmailAndPasswordCubit(
            useCase: sl<ChangeEmailAndPasswordUseCase>(),
            connectivityProvider: sl<ConnectivityProvider>()));
  }
}