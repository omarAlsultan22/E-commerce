import '../../../features/user_info/data/repositories_impl/user_info_repository_impl.dart';
import '../../providers/connectivity_provider.dart';
import '../../../features/user_info/presentation/cubits/user_info_cubit.dart';
import '../../../features/user_info/domain/use_cases/user_info_use_case.dart';
import 'package:international_cuisine/core/services/session_service.dart';
import '../../data/data_sources/remote/firestore_service_impl.dart';
import '../service _locator.dart';


class UserInfoDependencies {
  static void register() {
    // Repository
    sl.registerLazySingleton(() =>
        UserInfoRepositoryImpl(
            sessionService: sl<SessionService>(),
            dataSource: sl<FirestoreServiceImpl>()
        )
    );

    // UseCase
    sl.registerLazySingleton(() =>
        UserInfoUseCase(
            userInfoRepository: sl<UserInfoRepositoryImpl>()));

    // Cubit
    sl.registerFactory(() =>
        UserInfoCubit(
            userInfoUseCase: sl<UserInfoUseCase>(),
            connectivityProvider: sl<ConnectivityProvider>()));
  }
}