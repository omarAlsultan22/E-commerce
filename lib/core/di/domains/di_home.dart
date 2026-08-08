import 'package:international_cuisine/core/data/data_sources/local/shared_preferences.dart';
import '../../../features/home/data/repositories_impl/firestore_home_data_repository.dart';
import '../../../features/auth/data/repositories_impl/firebase_auth_repository.dart';
import '../../domain/services/connectivity_service/connectivity_provider.dart';
import '../../../features/home/presentation/cubits/home_data_cubit.dart';
import '../../../features/home/domain/useCases/home_data_useCase.dart';
import '../../../features/auth/domain/useCases/sign_out_useCase.dart';
import '../../data/data_sources/remote/firebase_auth.dart';
import '../../data/data_sources/remote/firestore.dart';
import '../service _locator.dart';


class HomeDependencies {
  static void register() {
    // Repositories
    sl.registerLazySingleton(() =>
        FirebaseAuthRepository(authService: sl<FirebaseAuthService>()));
    sl.registerLazySingleton(() =>
        FirestoreHomeDataRepository(repository: sl<FirestoreService>()));


    // UseCases
    sl.registerLazySingleton(() =>
        HomeDataUseCase(
            userInfoRepository: sl<FirestoreHomeDataRepository>()));


    sl.registerLazySingleton(() =>
        SignOutUseCase(
            cacheHelper: sl<CacheHelper>(),
            authRepository: sl<FirebaseAuthRepository>()));

    // Cubit
    sl.registerFactory(() =>
        HomeDataCubit(
          signOutUseCase: sl<SignOutUseCase>(),
          homeDataUseCase: sl<HomeDataUseCase>(),
          connectivityProvider: sl<ConnectivityProvider>(),
        ));
  }
}