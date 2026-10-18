import '../../../features/home/data/repositories_impl/home_data_repository_impl.dart';
import '../../../features/auth/data/repositories_impl/auth_repository_impl.dart';
import '../../domain/services/connectivity_service/connectivity_provider.dart';
import 'package:international_cuisine/core/services/session_service.dart';
import '../../../features/home/presentation/cubits/home_data_cubit.dart';
import '../../../features/home/domain/use_cases/home_data_use_case.dart';
import '../../../features/auth/domain/use_cases/sign_out_use_case.dart';
import '../../data/data_sources/remote/firestore_service_impl.dart';
import '../service _locator.dart';


class HomeDependencies {
  static void register() {
    // Repository
    sl.registerLazySingleton(() =>
        HomeDataRepositoryImpl(dataSource: sl<FirestoreServiceImpl>()));

    // UseCases
    sl.registerLazySingleton(() =>
        HomeDataUseCase(
            userInfoRepository: sl<HomeDataRepositoryImpl>()));

    sl.registerLazySingleton(() =>
        SignOutUseCase(
            sessionService: sl<SessionService>(),
            authRepository: sl<AuthRepositoryImpl>()));

    // Cubit
    sl.registerFactory(() =>
        HomeDataCubit(
          signOutUseCase: sl<SignOutUseCase>(),
          homeDataUseCase: sl<HomeDataUseCase>(),
          connectivityProvider: sl<ConnectivityProvider>(),
        ));
  }
}