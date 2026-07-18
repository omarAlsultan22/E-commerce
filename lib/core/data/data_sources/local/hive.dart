import 'package:hive_flutter/hive_flutter.dart';
import '../../../../features/cart/data/models/order_model.dart';
import 'package:international_cuisine/core/data/data_sources/local/shared_preferences.dart';


class HiveStore {
  final CacheHelper _cacheHelper;
  HiveStore({
    required CacheHelper cacheHelper
  }) : _cacheHelper = cacheHelper;

  static Box<OrderModel>? _box;

  Box<OrderModel> get box {
    if (_box == null || !_box!.isOpen) {
      throw Exception(
          'HiveOperations not initialized or box is closed. Call init() first.');
    }
    return _box!;
  }

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(OrderModelAdapter());
    _box = await Hive.openBox<OrderModel>('shoppingList');
    print('Box is opened..................');
  }

  Future<void> saveLocalData(List<OrderModel> value) async {
    try {
      if (_box == null || !_box!.isOpen) {
        print('im here>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.');
        await init();
      }

      await clearData();

      for (int i = 0; i < value.length; i++) {
        await _box!.put('item_$i', value[i]);
      }
    } catch (e) {
      print("Error saving local data: $e");
      rethrow;
    }
  }

  Future<List<OrderModel>> getLocalData() async {
    try {
      if (_box == null || !_box!.isOpen) {
        await init();
      }

      List<OrderModel> items = [];

      final count = await _cacheHelper.getIntValue(key: 'itemsCount') ?? 0;

      for (int i = 0; i < count; i++) {
        final item = await _box!.get('item_$i');
        if (item != null) {
          items.add(item);
        }
      }

      if (items.isEmpty) {
        return [];
      }

      return items;
    } catch (e) {
      print("Error getting local data: $e");
      return [];
    }
  }

  Future<void> clearData() async {
    try {
      if (_box != null && _box!.isOpen) {
        await _box!.clear();
      }
    } catch (e) {
      print("Error clearing data: $e");
    }
  }
}