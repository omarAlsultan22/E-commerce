import '../service _locator.dart';
import '../../data/data_sources/local/hive_impl.dart';
import '../../data/data_sources/remote/firestore_service_impl.dart';
import '../../data/data_sources/local/cache_helper_impl.dart';
import '../../data/data_sources/remote/auth_service_impl.dart';
import '../../providers/connectivity_provider.dart';


class CoreDependencies {

  static void register() {
    sl.registerLazySingleton(() => CacheHelperImpl());
    sl.registerLazySingleton(() => FirestoreServiceImpl());
    sl.registerLazySingleton(() => AuthServiceImpl());
    sl.registerLazySingleton(() => ConnectivityProvider());
    sl.registerLazySingleton(() => HiveStoreImpl(cacheHelper: sl<CacheHelperImpl>()));
  }
}