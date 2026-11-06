import 'package:international_cuisine/features/cart/data/models/order_model.dart';
import 'package:international_cuisine/features/cart/domain/repositories/shopping_list_repository.dart';


class FakeShoppingListRepository implements ShoppingListRepository {
  int saveDataCallCount = 0;
  List<OrderModel>? lastSaveData;
  Object? saveDataError;

  @override
  Future<void> saveDataToHive({required List<OrderModel> shoppingList}) async {
    saveDataCallCount++;
    lastSaveData = shoppingList;
    if (saveDataError != null) throw saveDataError!;
  }

  int getDataCallCount = 0;
  List<OrderModel> getDataResult = [];
  Object? getDataError;

  @override
  Future<List<OrderModel>> getDataFromHive() async {
    getDataCallCount++;
    if (getDataError != null) throw getDataError!;
    return getDataResult;
  }

  int clearDataCallCount = 0;
  Object? clearDataError;

  @override
  Future<void> clearDataFromHive() async {
    clearDataCallCount++;
    if (clearDataError != null) throw clearDataError!;
  }
}