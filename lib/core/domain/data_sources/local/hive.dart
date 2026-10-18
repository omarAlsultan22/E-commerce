import '../../../../features/cart/data/models/order_model.dart';


abstract class HiveStore {
  Future<void> init();

  Future<void> clearData();

  Future<List<OrderModel>> getLocalData();

  Future<void> saveLocalData(List<OrderModel> data);
}