import '../service _locator.dart';
import '../../services/session_service.dart';
import '../../domain/data_sources/local/hive.dart';
import '../../providers/connectivity_provider.dart';
import '../../network/data/connectivity_service.dart';
import '../../data/data_sources/local/hive_impl.dart';
import '../../network/domain/i_connectivity_service.dart';
import '../../domain/data_sources/local/cache_helper.dart';
import '../../domain/data_sources/remote/auth_service.dart';
import '../../data/data_sources/local/cache_helper_impl.dart';
import '../../data/data_sources/remote/auth_service_impl.dart';
import '../../domain/data_sources/remote/firestore_service.dart';
import '../../data/data_sources/remote/firestore_service_impl.dart';


class CoreDependencies {
  static void register() {
    sl.registerLazySingleton<CacheHelper>(() => CacheHelperImpl());
    sl.registerLazySingleton<AuthService>(() => AuthServiceImpl());
    sl.registerLazySingleton<SessionService>(() => SessionService());
    sl.registerLazySingleton<FirestoreService>(() => FirestoreServiceImpl());
    sl.registerLazySingleton<IConnectivityService>(() => ConnectivityService());
    sl.registerLazySingleton<ConnectivityProvider>(() => ConnectivityProvider());
    sl.registerLazySingleton<HiveStore>(() => HiveStoreImpl(cacheHelper: sl<CacheHelper>()));
  }
}