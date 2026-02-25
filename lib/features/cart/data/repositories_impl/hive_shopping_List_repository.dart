import 'package:international_cuisine/features/cart/data/models/order_model.dart';
import 'package:international_cuisine/core/data/data_sources/local/hive.dart';
import '../../domain/repositories/shopping_list_repository.dart';


class HiveShoppingListRepository implements ShoppingListRepository {
  final HiveStore _hiveStore;

  HiveShoppingListRepository({required HiveStore hiveStore})
      : _hiveStore = hiveStore;

  @override
  Future<void> saveDataToHive({
    required List<OrderModel> shoppingList
  }) async {
    try {
      await _hiveStore.saveLocalData(shoppingList);
    } catch (e) {
      throw Exception('Failed to save cart data: $e');
    }
  }

  @override
  Future<List<OrderModel>> getDataFromHive() async {
    try {
      final shoppingList = await _hiveStore.getLocalData();
      return shoppingList;
    } catch (e) {
      throw Exception('Failed to get cart data: $e');
    }
  }

  @override
  Future<void> removeItemFromHive({
    required int index
  }) async {
    try {
      await _hiveStore.removeItem(index);
    } catch (e) {
      throw Exception('Failed to remove item: $e');
    }
  }

  @override
  Future<void> clearDataFromHive() async {
    try {
      await _hiveStore.clearData();
    } catch (e) {
      throw Exception('Failed to clear cart data: $e');
    }
  }
}

