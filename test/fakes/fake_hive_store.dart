import 'package:international_cuisine/core/domain/data_sources/local/hive.dart';
import 'package:international_cuisine/features/cart/data/models/order_model.dart';


class FakeHiveStore implements HiveStore {
  // ===== saveLocalData =====
  int saveLocalDataCallCount = 0;
  List<OrderModel>? lastSaveData;
  Object? saveLocalDataError;

  @override
  Future<void> saveLocalData(List<OrderModel> data) async {
    saveLocalDataCallCount++;
    lastSaveData = data;
    if (saveLocalDataError != null) throw saveLocalDataError!;
  }

  // ===== getLocalData =====
  int getLocalDataCallCount = 0;
  List<OrderModel> getLocalDataResult = [];
  Object? getLocalDataError;

  @override
  Future<List<OrderModel>> getLocalData() async {
    getLocalDataCallCount++;
    if (getLocalDataError != null) throw getLocalDataError!;
    return getLocalDataResult;
  }

  // ===== clearData =====
  int clearDataCallCount = 0;
  Object? clearDataError;

  @override
  Future<void> clearData() async {
    clearDataCallCount++;
    if (clearDataError != null) throw clearDataError!;
  }

  // ===== init (إن كانت في الواجهة) =====
  @override
  Future<void> init() async {}
}