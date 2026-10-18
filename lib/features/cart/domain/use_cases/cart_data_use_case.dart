import '../repositories/shopping_list_repository.dart';
import 'package:international_cuisine/core/constants/app_keys.dart';
import '../../../../core/data/data_sources/local/cache_helper_impl.dart';
import 'package:international_cuisine/features/cart/data/models/order_model.dart';


class CartDataUseCase {
  final CacheHelperImpl _cacheHelper;
  ShoppingListRepository _repository;

  CartDataUseCase({
    required CacheHelperImpl cacheHelper,
    required ShoppingListRepository repository
  })
      : _repository = repository,
        _cacheHelper = cacheHelper;

  static const time = AppKeys.time;

  Future<void> saveCartDataExecute({
    required List<OrderModel> shoppingList
  }) async {
    await clearCartExecute();
    await _repository.saveDataToHive(shoppingList: shoppingList);
    await _cacheHelper.setInt(
        key: 'itemsCount', value: shoppingList.length);
    await _cacheHelper.setInt(key: time, value: DateTime
        .now()
        .millisecondsSinceEpoch);
  }

  Future<List<OrderModel>> getCartDataExecute() async {
    final savedTime = await _cacheHelper.getInt(key: time) ??
        0;
    final currentTime = DateTime
        .now()
        .millisecondsSinceEpoch;
    const expiryHours = 1;
    const expiryMilliseconds = expiryHours * 60 * 60 * 1000;

    if (savedTime == 0 || currentTime - savedTime > expiryMilliseconds) {
      print('Cart data expired or not found, removing...');
      await _cacheHelper.removeValue(key: time);
      await clearCartExecute();
      return [];
    } else {
      return await _repository.getDataFromHive();
    }
  }

  Future<void> clearCartExecute() async {
    _repository.clearDataFromHive();
  }
}