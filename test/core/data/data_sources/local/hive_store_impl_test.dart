import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:international_cuisine/features/cart/data/models/order_model.dart';
import 'package:international_cuisine/core/data/data_sources/local/hive_impl.dart';
import 'package:international_cuisine/core/errors/exceptions/cache_exceptions/hive_app_exceptions.dart';
import '../../../../fakes/fake_cache_helper.dart';

class MockHiveInterface extends Mock implements HiveInterface {}
class MockBox extends Mock implements Box<OrderModel> {}

void main() {
  late MockBox mockBox;
  late HiveStoreImpl store;
  late FakeCacheHelper fakeCache;
  late MockHiveInterface mockHive;

  final order1 = OrderModel(order: 'Pizza', image: 'pizza.jpg', price: 10);
  final order2 = OrderModel(order: 'Burger', image: 'burger.jpg', price: 20);

  setUp(() {
    mockHive = MockHiveInterface();
    mockBox = MockBox();
    fakeCache = FakeCacheHelper();
    store = HiveStoreImpl(cacheHelper: fakeCache, hive: mockHive);

    when(() => mockHive.registerAdapter<OrderModel>(any())).thenAnswer((_) {});
    when(() => mockHive.openBox<OrderModel>('shoppingList'))
        .thenAnswer((_) async => mockBox);
    when(() => mockBox.isOpen).thenReturn(true);
  });

  group('init', () {
    test('registers adapter and opens box', () async {
      await store.init();

      verify(() => mockHive.registerAdapter<OrderModel>(any())).called(1);
      verify(() => mockHive.openBox<OrderModel>('shoppingList')).called(1);
    });

    test('throws HiveInitializeException when openBox fails', () async {
      when(() => mockHive.openBox<OrderModel>('shoppingList'))
          .thenThrow(Exception('disk full'));

      expect(() => store.init(), throwsA(isA<HiveInitializeException>()));
    });
  });

  group('box getter', () {
    test('throws HiveInitializeException before init', () {
      expect(() => store.box, throwsA(isA<HiveInitializeException>()));
    });

    test('returns box after init', () async {
      await store.init();
      expect(store.box, same(mockBox));
    });
  });

  group('saveLocalData', () {
    test('saves items with sequential keys', () async {
      await store.init();
      when(() => mockBox.put(any(), any())).thenAnswer((_) async {});

      await store.saveLocalData([order1, order2]);

      verify(() => mockBox.put('item_0', order1)).called(1);
      verify(() => mockBox.put('item_1', order2)).called(1);
    });

    test('auto-initializes when box is null', () async {
      when(() => mockBox.put(any(), any())).thenAnswer((_) async {});

      await store.saveLocalData([order1]);

      verify(() => mockHive.openBox<OrderModel>('shoppingList')).called(1);
    });

    test('throws HiveSaveException when put fails', () async {
      await store.init();
      when(() => mockBox.put(any(), any())).thenThrow(Exception('write failed'));

      expect(
            () => store.saveLocalData([order1]),
        throwsA(isA<HiveSaveException>()),
      );
    });
  });

  group('getLocalData', () {
    test('returns items based on itemsCount', () async {
      await store.init();
      await fakeCache.setInt(key: 'itemsCount', value: 2);
      when(() => mockBox.get('item_0')).thenReturn(order1);
      when(() => mockBox.get('item_1')).thenReturn(order2);

      final result = await store.getLocalData();

      expect(result.length, 2);
      expect(result[0].order, 'Pizza');
      expect(result[1].order, 'Burger');
    });

    test('returns empty list when count is 0', () async {
      await store.init();
      // itemsCount غير موجود → 0

      final result = await store.getLocalData();

      expect(result, isEmpty);
    });

    test('skips null items', () async {
      await store.init();
      await fakeCache.setInt(key: 'itemsCount', value: 3);
      when(() => mockBox.get('item_0')).thenReturn(order1);
      when(() => mockBox.get('item_1')).thenReturn(null);
      when(() => mockBox.get('item_2')).thenReturn(order2);

      final result = await store.getLocalData();

      expect(result.length, 2);
      expect(result[0].order, 'Pizza');
      expect(result[1].order, 'Burger');
    });

    test('throws HiveReadException when get fails', () async {
      await store.init();
      await fakeCache.setInt(key: 'itemsCount', value: 1);
      when(() => mockBox.get(any())).thenThrow(Exception('read failed'));

      expect(() => store.getLocalData(), throwsA(isA<HiveReadException>()));
    });
  });

  group('clearData', () {
    test('clears the box', () async {
      await store.init();
      when(() => mockBox.clear()).thenAnswer((_) async => 0);

      await store.clearData();

      verify(() => mockBox.clear()).called(1);
    });

    test('does nothing when box is null', () async {
      await store.clearData();
      // لا يرمي
    });
  });
}