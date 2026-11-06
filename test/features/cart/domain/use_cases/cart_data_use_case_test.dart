import 'package:flutter_test/flutter_test.dart';
import '../../../../fakes/fake_cache_helper.dart';
import '../../../../fakes/fake_shopping_list_repository.dart';
import 'package:international_cuisine/core/constants/app_keys.dart';
import 'package:international_cuisine/features/cart/data/models/order_model.dart';
import 'package:international_cuisine/features/cart/domain/use_cases/cart_data_use_case.dart';


void main() {
  late FakeCacheHelper fakeCache;
  late FakeShoppingListRepository fakeRepo;
  late CartDataUseCase useCase;

  final order1 = OrderModel(order: 'Pizza', image: 'p.jpg', price: 10);
  final order2 = OrderModel(order: 'Burger', image: 'b.jpg', price: 20);

  setUp(() {
    fakeCache = FakeCacheHelper();
    fakeRepo = FakeShoppingListRepository();
    useCase = CartDataUseCase(
      cacheHelper: fakeCache,
      repository: fakeRepo,
    );
  });

  group('saveCartDataExecute', () {
    test('clears, saves, and updates counts', () async {
      await useCase.saveCartDataExecute(shoppingList: [order1, order2]);

      expect(fakeRepo.clearDataCallCount, 1);
      expect(fakeRepo.saveDataCallCount, 1);
      expect(fakeRepo.lastSaveData, [order1, order2]);
      expect(await fakeCache.getInt(key: 'itemsCount'), 2);
      expect(await fakeCache.getInt(key: AppKeys.time), isNotNull);
    });

    test('saves timestamp as millisecondsSinceEpoch', () async {
      final before = DateTime.now().millisecondsSinceEpoch;
      await useCase.saveCartDataExecute(shoppingList: [order1]);
      final after = DateTime.now().millisecondsSinceEpoch;

      final savedTime = await fakeCache.getInt(key: AppKeys.time);
      expect(savedTime, isNotNull);
      expect(savedTime, greaterThanOrEqualTo(before));
      expect(savedTime, lessThanOrEqualTo(after));
    });

    test('propagates errors from saveDataToHive', () async {
      fakeRepo.saveDataError = Exception('save failed');

      expect(
            () => useCase.saveCartDataExecute(shoppingList: [order1]),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('getCartDataExecute', () {
    test('returns empty list when savedTime is 0', () async {
      // لا time محفوظ → 0
      final result = await useCase.getCartDataExecute();

      expect(result, isEmpty);
      expect(fakeRepo.clearDataCallCount, 1);
    });

    test('returns empty list when expired (over 1 hour)', () async {
      final twoHoursAgo = DateTime.now()
          .subtract(const Duration(hours: 2))
          .millisecondsSinceEpoch;
      await fakeCache.setInt(key: AppKeys.time, value: twoHoursAgo);

      final result = await useCase.getCartDataExecute();

      expect(result, isEmpty);
      expect(fakeRepo.clearDataCallCount, 1);
    });

    test('returns data when not expired (under 1 hour)', () async {
      final thirtyMinutesAgo = DateTime.now()
          .subtract(const Duration(minutes: 30))
          .millisecondsSinceEpoch;
      await fakeCache.setInt(key: AppKeys.time, value: thirtyMinutesAgo);
      fakeRepo.getDataResult = [order1, order2];

      final result = await useCase.getCartDataExecute();

      expect(result, [order1, order2]);
      expect(fakeRepo.getDataCallCount, 1);
      expect(fakeRepo.clearDataCallCount, 0);
    });

    test('removes time key when expired', () async {
      final twoHoursAgo = DateTime.now()
          .subtract(const Duration(hours: 2))
          .millisecondsSinceEpoch;
      await fakeCache.setInt(key: AppKeys.time, value: twoHoursAgo);

      await useCase.getCartDataExecute();

      expect(await fakeCache.getInt(key: AppKeys.time), isNull);
    });
  });

  group('clearCartExecute', () {
    test('delegates to repository.clearDataFromHive', () async {
      await useCase.clearCartExecute();

      expect(fakeRepo.clearDataCallCount, 1);
    });

    test('does not await clearDataFromHive (documents bug)', () async {
      // في الكود: _repository.clearDataFromHive(); (بدون await)
      fakeRepo.clearDataError = Exception('clear failed');

      // clearCartExecute لا ينتظر → لا يرمي
      await useCase.clearCartExecute();

      // لو كان await → لرمى Exception
    });
  });
}