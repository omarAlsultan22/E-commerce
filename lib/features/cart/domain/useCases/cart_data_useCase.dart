import '../repositories/shopping_list_repository.dart';
import '../../../../core/data/data_sources/local/shared_preferences.dart';
import 'package:international_cuisine/features/cart/data/models/order_model.dart';


class CartDataUseCase {
  ShoppingListRepository _repository;

  CartDataUseCase({
    required ShoppingListRepository repository
  })
      : _repository = repository;


  Future<void> saveCartDataExecute({
    required List<OrderModel> shoppingList
  }) async {
    try {
      _repository.saveDataToHive(shoppingList: shoppingList);
    }
    catch (e) {
      rethrow;
    }
  }

  Future<List<OrderModel>> getCartDataExecute() async {
    try {
      final savedTime = await CacheHelper.getIntValue(key: 'cart_saved_time') ??
          0;
      final currentTime = DateTime
          .now()
          .millisecondsSinceEpoch;
      const expiryHours = 1;
      const expiryMilliseconds = expiryHours * 60 * 60 * 1000;

      if (savedTime == 0 || currentTime - savedTime > expiryMilliseconds) {
        print('Cart data expired or not found, removing...');
        await CacheHelper.removeValue(key: 'cartData');
        await CacheHelper.removeValue(key: 'cart_saved_time');
        return [];
      } else {
        return _repository.getDataFromHive();
      }
    }
    catch (e) {
      throw Exception('Failed to load cart data: $e');
    }
  }

  Future<void> removeItemExecute({required int index}) async {
    try {
      _repository.removeItemFromHive(index: index);
    }
    catch (e) {
      rethrow;
    }
  }

  Future<void> clearCartExecute() async {
    try {
      _repository.clearDataFromHive();
    }
    catch (e) {
      rethrow;
    }
  }
}