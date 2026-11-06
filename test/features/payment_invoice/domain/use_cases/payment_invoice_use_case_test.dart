import 'package:flutter_test/flutter_test.dart';
import '../../../../fakes/fake_payment_invoice_repository.dart';
import 'package:international_cuisine/core/data/models/user_model.dart';
import 'package:international_cuisine/features/cart/data/models/order_model.dart';
import 'package:international_cuisine/features/payment_invoice/domain/use_cases/payment_Invoice_use_case.dart';


void main() {
  late FakePaymentInvoiceRepository fakeRepo;
  late PaymentInvoiceUseCase useCase;

  final order1 = OrderModel(order: 'Pizza', image: 'p.jpg', price: 10);
  final order2 = OrderModel(order: 'Burger', image: 'b.jpg', price: 20);

  setUp(() {
    fakeRepo = FakePaymentInvoiceRepository();
    useCase = PaymentInvoiceUseCase(userInfoRepository: fakeRepo);
  });

  group('getInfoExecute', () {
    test('returns UserModel from repository', () async {
      final expected = UserModel(
        firstName: 'Sara',
        lastName: 'Mohamed',
        userPhone: '9999',
        userLocation: 'Alexandria',
      );
      fakeRepo.getInfoResult = expected;

      final result = await useCase.getInfoExecute();

      expect(result, same(expected));
      expect(fakeRepo.getInfoCallCount, 1);
    });

    test('propagates errors from repository', () async {
      fakeRepo.getInfoError = Exception('fetch failed');

      expect(
            () => useCase.getInfoExecute(),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('sendDataExecute', () {
    test('passes userInfo and shoppingList to repository', () async {
      final userInfo = UserModel(
        firstName: 'Ali',
        lastName: 'Ahmed',
        userPhone: '0123',
        userLocation: 'Cairo',
      );

      await useCase.sendDataExecute(
        userInfo: userInfo,
        shoppingList: [order1, order2],
      );

      expect(fakeRepo.sendOrdersCallCount, 1);
      expect(fakeRepo.lastUserInfo, same(userInfo));
      expect(fakeRepo.lastShoppingList, [order1, order2]);
    });

    test('passes null userInfo correctly', () async {
      await useCase.sendDataExecute(
        userInfo: null,
        shoppingList: [order1],
      );

      expect(fakeRepo.sendOrdersCallCount, 1);
      expect(fakeRepo.lastUserInfo, isNull);
    });

    test('propagates errors from repository', () async {
      fakeRepo.sendOrdersError = Exception('send failed');
      final userInfo = UserModel(
        firstName: 'Ali',
        lastName: 'Ahmed',
        userPhone: '0123',
        userLocation: 'Cairo',
      );

      expect(
            () => useCase.sendDataExecute(
          userInfo: userInfo,
          shoppingList: [order1],
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}