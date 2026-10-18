import 'package:hive_flutter/hive_flutter.dart';
import '../../../../features/cart/data/models/order_model.dart';
import '../../../errors/exceptions/cache_exceptions/hive_app_exceptions.dart';
import 'package:international_cuisine/core/domain/data_sources/local/hive.dart';
import 'package:international_cuisine/core/data/data_sources/local/cache_helper_impl.dart';


class HiveStoreImpl implements HiveStore {
  final CacheHelperImpl _cacheHelper;

  HiveStoreImpl({
    required CacheHelperImpl cacheHelper
  }) : _cacheHelper = cacheHelper;

  static Box<OrderModel>? _box;

  Box<OrderModel> get box {
    if (_box == null || !_box!.isOpen) {
      throw HiveInitializeException();
    }
    return _box!;
  }

  @override
  Future<void> init() async {
    try {
      await Hive.initFlutter();
      Hive.registerAdapter(OrderModelAdapter());
      _box = await Hive.openBox<OrderModel>('shoppingList');
    }
    catch (e) {
      throw HiveInitializeException(error: e);
    }
  }

  @override
  Future<void> saveLocalData(List<OrderModel> data) async {
    try {
      if (_box == null || !_box!.isOpen) {
        await init();
      }

      for (int i = 0; i < data.length; i++) {
        await _box!.put('item_$i', data[i]);
      }
    } catch (e) {
      print("Error saving local data: $e");
      throw HiveSaveException(error: e);
    }
  }

  @override
  Future<List<OrderModel>> getLocalData() async {
    try {
      if (_box == null || !_box!.isOpen) {
        await init();
      }

      List<OrderModel> items = [];

      final count = await _cacheHelper.getInt(key: 'itemsCount') ?? 0;

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
    }
    catch (e) {
      print("Error getting local data: $e");
      throw HiveReadException(error: e);
    }
  }

  @override
  Future<void> clearData() async {
    try {
      if (_box != null && _box!.isOpen) {
        await _box!.clear();
      }
    }
    catch (e) {
      print("Error clearing data: $e");
      throw HiveClearException(error: e);
    }
  }
}