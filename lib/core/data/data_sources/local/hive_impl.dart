import 'package:hive_flutter/hive_flutter.dart';
import '../../../domain/data_sources/local/cache_helper.dart';
import '../../../../features/cart/data/models/order_model.dart';
import '../../../errors/exceptions/cache_exceptions/hive_app_exceptions.dart';
import 'package:international_cuisine/core/domain/data_sources/local/hive.dart';

class HiveStoreImpl implements HiveStore {
  final CacheHelper _cacheHelper;
  final HiveInterface _hive;
  Box<OrderModel>? _box;

  HiveStoreImpl({
    required CacheHelper cacheHelper,
    HiveInterface? hive,
  })  : _cacheHelper = cacheHelper,
        _hive = hive ?? Hive;

  Box<OrderModel> get box {
    if (_box == null || !_box!.isOpen) {
      throw HiveInitializeException();
    }
    return _box!;
  }

  @override
  Future<void> init() async {
    try {
      _hive.initFlutter();
      _hive.registerAdapter(OrderModelAdapter());
      _box = await _hive.openBox<OrderModel>('shoppingList');
    } catch (e) {
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
        final item = _box!.get('item_$i');  // ← get ليس async
        if (item != null) {
          items.add(item);
        }
      }

      return items;
    } catch (e) {
      throw HiveReadException(error: e);
    }
  }

  @override
  Future<void> clearData() async {
    try {
      if (_box != null && _box!.isOpen) {
        await _box!.clear();
      }
    } catch (e) {
      throw HiveClearException(error: e);
    }
  }
}