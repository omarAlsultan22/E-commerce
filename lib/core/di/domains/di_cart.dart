import '../../../features/cart/data/repositories_impl/shopping_List_repository_impl.dart';
import 'package:international_cuisine/core/data/data_sources/local/cache_helper_impl.dart';
import '../../../features/cart/presentation/cubits/cart_data_cubit.dart';
import '../../../features/cart/domain/use_cases/cart_data_use_case.dart';
import '../../data/data_sources/local/hive_impl.dart';
import '../service _locator.dart';


class CartDependencies {
  static void register() {
    // Repository
    sl.registerLazySingleton(() =>
        ShoppingListRepositoryImpl(hiveStore: sl<HiveStoreImpl>()));

    // UseCase
    sl.registerLazySingleton(() =>
        CartDataUseCase(
            repository: sl<ShoppingListRepositoryImpl>(),
            cacheHelper: sl<CacheHelperImpl>()));

    // Cubit
    sl.registerLazySingleton(() => CartDataCubit(useCase: sl<CartDataUseCase>()));
  }
}