import 'package:international_cuisine/core/data/data_sources/local/shared_preferences.dart';
import '../../../features/cart/data/repositories_impl/hive_shopping_List_repository.dart';
import '../../../features/cart/presentation/cubits/cart_data_cubit.dart';
import '../../../features/cart/domain/useCases/cart_data_useCase.dart';
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