import 'package:flutter_test/flutter_test.dart';
import '../../../../fakes/fake_hive_store.dart';
import 'package:international_cuisine/features/cart/data/models/order_model.dart';
import 'package:international_cuisine/features/cart/domain/repositories/shopping_list_repository.dart';
import 'package:international_cuisine/core/errors/exceptions/cache_exceptions/hive_app_exceptions.dart';
import 'package:international_cuisine/features/cart/data/repositories_impl/shopping_List_repository_impl.dart';


void main() {
  late FakeHiveStore fakeHiveStore;
  late ShoppingListRepository repository;

  final order1 = OrderModel(order: 'Pizza', image: 'p.jpg', price: 10);
  final order2 = OrderModel(order: 'Burger', image: 'b.jpg', price: 20);

  setUp(() {
    fakeHiveStore = FakeHiveStore();
    repository = ShoppingListRepositoryImpl(hiveStore: fakeHiveStore);
  });

  group('saveDataToHive', () {
    test('delegates to hiveStore.saveLocalData', () async {
      await repository.saveDataToHive(shoppingList: [order1, order2]);

      expect(fakeHiveStore.saveLocalDataCallCount, 1);
      expect(fakeHiveStore.lastSaveData, [order1, order2]);
    });

    test('wraps errors in HiveSaveException', () async {
      fakeHiveStore.saveLocalDataError = Exception('write failed');

      expect(
            () => repository.saveDataToHive(shoppingList: [order1]),
        throwsA(isA<HiveSaveException>()),
      );
    });
  });

  group('getDataFromHive', () {
    test('returns data from hiveStore.getLocalData', () async {
      fakeHiveStore.getLocalDataResult = [order1, order2];

      final result = await repository.getDataFromHive();

      expect(result, [order1, order2]);
      expect(fakeHiveStore.getLocalDataCallCount, 1);
    });

    test('returns empty list when hiveStore is empty', () async {
      final result = await repository.getDataFromHive();

      expect(result, isEmpty);
    });

    test('wraps errors in HiveReadException', () async {
      fakeHiveStore.getLocalDataError = Exception('read failed');

      expect(
            () => repository.getDataFromHive(),
        throwsA(isA<HiveReadException>()),
      );
    });
  });

  group('clearDataFromHive', () {
    test('delegates to hiveStore.clearData', () async {
      await repository.clearDataFromHive();

      expect(fakeHiveStore.clearDataCallCount, 1);
    });

    test('wraps errors in HiveClearException', () async {
      fakeHiveStore.clearDataError = Exception('clear failed');

      expect(
            () => repository.clearDataFromHive(),
        throwsA(isA<HiveClearException>()),
      );
    });
  });
}