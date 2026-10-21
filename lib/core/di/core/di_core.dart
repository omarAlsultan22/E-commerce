import '../service _locator.dart';
import '../../services/session_service.dart';
import '../../providers/connectivity_provider.dart';
import '../../network/data/connectivity_service.dart';
import '../../data/data_sources/local/hive_impl.dart';
import '../../data/data_sources/local/cache_helper_impl.dart';
import '../../data/data_sources/remote/auth_service_impl.dart';
import '../../data/data_sources/remote/firestore_service_impl.dart';


class CoreDependencies {
  static void register() {
    sl.registerLazySingleton(() => SessionService());
    sl.registerLazySingleton(() => CacheHelperImpl());
    sl.registerLazySingleton(() => AuthServiceImpl());
    sl.registerLazySingleton(() => ConnectivityService());
    sl.registerLazySingleton(() => ConnectivityProvider());
    sl.registerLazySingleton(() => FirestoreServiceImpl());
    sl.registerLazySingleton(() => HiveStoreImpl(cacheHelper: sl<CacheHelperImpl>()));
  }
}