import '../../../features/user_info/data/repositories_impl/user_info_repository_impl.dart';
import '../../../features/user_info/domain/repositories/user_info_repository.dart';
import '../../../features/user_info/presentation/cubits/user_info_cubit.dart';
import '../../../features/user_info/domain/use_cases/user_info_use_case.dart';
import 'package:international_cuisine/core/services/session_service.dart';
import '../../domain/data_sources/remote/firestore_service.dart';
import '../../providers/connectivity_provider.dart';
import '../service _locator.dart';


class UserInfoDependencies {
  static void register() {
    // Repository
    sl.registerLazySingleton<UserInfoRepository>(() =>
        UserInfoRepositoryImpl(
            sessionService: sl<SessionService>(),
            dataSource: sl<FirestoreService>()
        )
    );

    // UseCase
    sl.registerLazySingleton<UserInfoUseCase>(() =>
        UserInfoUseCase(
            userInfoRepository: sl<UserInfoRepository>()));

    // Cubit
    sl.registerFactory<UserInfoCubit>(() =>
        UserInfoCubit(
            userInfoUseCase: sl<UserInfoUseCase>(),
            connectivityProvider: sl<ConnectivityProvider>()));
  }
}