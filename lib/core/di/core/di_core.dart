import '../service _locator.dart';
import '../../data/data_sources/local/hive.dart';
import '../../data/data_sources/remote/firestore.dart';
import '../../data/data_sources/local/cache_Helper.dart';
import '../../data/data_sources/remote/firebase_auth.dart';
import '../../domain/services/connectivity_service/connectivity_provider.dart';


class CoreDependencies {

  static void register() {
    sl.registerLazySingleton(() => CacheHelper());
    sl.registerLazySingleton(() => FirestoreService());
    sl.registerLazySingleton(() => FirebaseAuthService());
    sl.registerLazySingleton(() => ConnectivityProvider());
    sl.registerLazySingleton(() => HiveStore(cacheHelper: sl<CacheHelper>()));
  }
}