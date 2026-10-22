import '../../../features/cart/data/repositories_impl/shopping_List_repository_impl.dart';
import '../../../features/cart/domain/repositories/shopping_list_repository.dart';
import '../../../features/cart/presentation/cubits/cart_data_cubit.dart';
import '../../../features/cart/domain/use_cases/cart_data_use_case.dart';
import '../../domain/data_sources/local/cache_helper.dart';
import '../../domain/data_sources/local/hive.dart';
import '../service _locator.dart';


class CartDependencies {
  static void register() {
    // Repository
    sl.registerLazySingleton<ShoppingListRepository>(() =>
        ShoppingListRepositoryImpl(hiveStore: sl<HiveStore>()));

    // UseCase
    sl.registerLazySingleton<CartDataUseCase>(() =>
        CartDataUseCase(
            cacheHelper: sl<CacheHelper>(),
            repository: sl<ShoppingListRepository>()
        ));

    // Cubit
    sl.registerLazySingleton<CartDataCubit>(() =>
        CartDataCubit(useCase: sl<CartDataUseCase>()));
  }
}