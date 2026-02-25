import '../../../../features/cart/data/models/order_model.dart';
import 'package:hive_flutter/hive_flutter.dart';


class HiveStore {
  static Box<List<OrderModel>>? _box;
  static const String _boxName = 'shoppingList';

  static Box<List<OrderModel>> get box {
    if (_box == null || !_box!.isOpen) {
      throw Exception('HiveOperations not initialized or box is closed. Call init() first.');
    }
    return _box!;
  }

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(OrderModelAdapter());
    _box = await Hive.openBox<List<OrderModel>>('shoppingList');
    print('Box is opened..................');
  }

  Future<void> saveLocalData(List<OrderModel> value) async {
    try {
      if (_box == null || !_box!.isOpen) {
        await init();
      }

      await _box!.put(_boxName, value);
      print("Data saved successfully for key: $_boxName");
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

      final value = _box!.get(_boxName);

      if (value == null) {
        return [];
      }

      return List<OrderModel>.from(value);

    } catch (e) {
      print("Error getting local data: $e");
      return [];
    }
  }

  Future<void> removeItem(int index) async {
    try {
      if (_box != null && _box!.isOpen) {
        await _box!.delete(index);
      }
    } catch (e) {
      print("Error deleting data: $e");
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


  static Future<void> closeBox() async {
    try {
      await _box?.close();
    } catch (e) {
      print("Error closing box: $e");
    }
  }

  static bool get isInitialized => _box != null && _box!.isOpen;
}