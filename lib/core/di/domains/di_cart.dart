import '../../../features/cart/data/repositories_impl/hive_shopping_List_repository.dart';
import 'package:international_cuisine/core/data/data_sources/local/cache_helper.dart';
import '../../../features/cart/presentation/cubits/cart_data_cubit.dart';
import '../../../features/cart/domain/use_cases/cart_data_use_case.dart';
import '../../data/data_sources/local/hive.dart';
import '../service _locator.dart';


class CartDependencies {
  static void register() {
    // Repository
    sl.registerLazySingleton(() =>
        HiveShoppingListRepository(hiveStore: sl<HiveStore>()));

    // UseCase
    sl.registerLazySingleton(() =>
        CartDataUseCase(
            repository: sl<HiveShoppingListRepository>(),
            cacheHelper: sl<CacheHelper>()));

    // Cubit
    sl.registerLazySingleton(() => CartDataCubit(useCase: sl<CartDataUseCase>()));
  }
}