import '../../../../core/domain/data_sources/local/hive.dart';
import '../../domain/repositories/shopping_list_repository.dart';
import 'package:international_cuisine/features/cart/data/models/order_model.dart';
import 'package:international_cuisine/core/errors/exceptions/cache_exceptions/hive_app_exceptions.dart';


class ShoppingListRepositoryImpl implements ShoppingListRepository {
  final HiveStore _hiveStore;

  ShoppingListRepositoryImpl({required HiveStore hiveStore})
      : _hiveStore = hiveStore;

  @override
  Future<void> saveDataToHive({
    required List<OrderModel> shoppingList
  }) async {
    try {
      await _hiveStore.saveLocalData(shoppingList);
    } catch (e) {
      throw HiveSaveException(error: e);
    }
  }

  @override
  Future<List<OrderModel>> getDataFromHive() async {
    try {
      final shoppingList = await _hiveStore.getLocalData();
      return shoppingList;
    } catch (e) {
      throw HiveReadException(error: e);
    }
  }

  @override
  Future<void> clearDataFromHive() async {
    try {
      await _hiveStore.clearData();
    } catch (e) {
      throw HiveClearException(error: e);
    }
  }
}

