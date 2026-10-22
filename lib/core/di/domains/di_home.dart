import '../../../features/home/data/repositories_impl/home_data_repository_impl.dart';
import '../../../features/home/domain/repositories/home_data_repository.dart';
import 'package:international_cuisine/core/services/session_service.dart';
import '../../../features/home/presentation/cubits/home_data_cubit.dart';
import '../../../features/home/domain/use_cases/home_data_use_case.dart';
import '../../../features/auth/domain/repositories/auth_repository.dart';
import '../../../features/auth/domain/use_cases/sign_out_use_case.dart';
import '../../domain/data_sources/remote/firestore_service.dart';
import '../../providers/connectivity_provider.dart';
import '../service _locator.dart';


class HomeDependencies {
  static void register() {
    // Repository
    sl.registerLazySingleton<HomeDataRepository>(() =>
        HomeDataRepositoryImpl(dataSource: sl<FirestoreService>()));

    // UseCases
    sl.registerLazySingleton<HomeDataUseCase>(() =>
        HomeDataUseCase(
            userInfoRepository: sl<HomeDataRepository>()));

    sl.registerLazySingleton<SignOutUseCase>(() =>
        SignOutUseCase(
            sessionService: sl<SessionService>(),
            authRepository: sl<AuthRepository>()));

    // Cubit
    sl.registerFactory<HomeDataCubit>(() =>
        HomeDataCubit(
          signOutUseCase: sl<SignOutUseCase>(),
          homeDataUseCase: sl<HomeDataUseCase>(),
          connectivityProvider: sl<ConnectivityProvider>(),
        ));
  }
}