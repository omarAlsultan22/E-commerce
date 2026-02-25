import 'package:international_cuisine/features/cart/data/models/order_model.dart';


abstract class ShoppingListRepository {
  Future<List<OrderModel>> getDataFromHive();

  Future<void> saveDataToHive({
    required List<OrderModel> shoppingList
  });

  Future<void> removeItemFromHive({
    required int index
});

  Future<void> clearDataFromHive();
}