import '../../../features/user_info/data/repositories_impl/firestore_user_info_repository.dart';
import 'package:international_cuisine/core/data/data_sources/local/cache_helper.dart';
import '../../domain/services/connectivity_service/connectivity_provider.dart';
import '../../../features/user_info/presentation/cubits/user_info_cubit.dart';
import '../../../features/user_info/domain/useCases/user_info_useCase.dart';
import 'package:international_cuisine/core/services/session_service.dart';
import '../../data/data_sources/remote/firestore.dart';
import '../service _locator.dart';


class UserInfoDependencies {
  static void register() {
    // Repository
    sl.registerLazySingleton(() =>
        FirestoreUserInfoRepository(
            sessionService: sl<SessionService>(),
            repository: sl<FirestoreService>(),
            cacheHelper: sl<CacheHelper>()));

    // UseCase
    sl.registerLazySingleton(() =>
        UserInfoUseCase(
            userInfoRepository: sl<FirestoreUserInfoRepository>()));

    // Cubit
    sl.registerFactory(() =>
        UserInfoCubit(
            userInfoUseCase: sl<UserInfoUseCase>(),
            connectivityProvider: sl<ConnectivityProvider>()));
  }
}