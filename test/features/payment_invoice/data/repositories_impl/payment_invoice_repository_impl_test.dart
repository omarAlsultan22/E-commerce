import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../fakes/fake_cache_helper.dart';
import '../../../../fakes/mock_session_service.dart';
import '../../../../fakes/fake_firestore_service.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:international_cuisine/core/constants/app_keys.dart';
import 'package:international_cuisine/core/data/models/user_model.dart';
import 'package:international_cuisine/features/cart/data/models/order_model.dart';
import 'package:international_cuisine/core/errors/exceptions/validation_exception.dart';
import 'package:international_cuisine/features/payment_invoice/domain/repositories/payment_invoice_repository.dart';
import 'package:international_cuisine/features/payment_invoice/data/repositories_impl/payment_invoice_repository_impl.dart';


void main() {
  late FakeCacheHelper fakeCache;
  late MockSessionService mockSession;
  late FakeFirebaseFirestore fakeFirestore;
  late FakeFirestoreService fakeDataSource;
  late PaymentInvoiceRepository repository;

  final order1 = OrderModel(order: 'Pizza', image: 'p.jpg', price: 10);
  final order2 = OrderModel(order: 'Burger', image: 'b.jpg', price: 20);

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    fakeCache = FakeCacheHelper();
    fakeDataSource = FakeFirestoreService();
    mockSession = MockSessionService();
    when(() => mockSession.currentUid).thenReturn('user-123');
    repository = PaymentInvoiceRepositoryImpl(
        cacheHelper: fakeCache,
        dataSource: fakeDataSource,
        sessionService: mockSession
    );
  });

  group('getInfo', () {
    test('reads location from cache', () async {
      await fakeCache.setString(key: AppKeys.location, value: 'Cairo');
      await fakeFirestore.collection(AppKeys.userInfo).doc(
          'Lcjp7FoCPAo0U3yqqRmm').set({
        'firstName': 'Ali',
        'lastName': 'Ahmed',
      });
      final doc = await fakeFirestore
          .collection(AppKeys.userInfo)
          .doc('Lcjp7FoCPAo0U3yqqRmm')
          .get();
      fakeDataSource.documentToReturn = doc;

      await repository.getInfo();

      expect(await fakeCache.getString(key: AppKeys.location), 'Cairo');
    });

    test('calls getDocument with fixed docId (documents bug)', () async {
      await fakeCache.setString(key: AppKeys.location, value: 'Cairo');
      await fakeFirestore.collection(AppKeys.userInfo).doc(
          'Lcjp7FoCPAo0U3yqqRmm').set({
        'firstName': 'Ali',
      });
      final doc = await fakeFirestore
          .collection(AppKeys.userInfo)
          .doc('Lcjp7FoCPAo0U3yqqRmm')
          .get();
      fakeDataSource.documentToReturn = doc;

      await repository.getInfo();

      expect(fakeDataSource.lastGetCollectionPath, AppKeys.userInfo);
      // ← bug: docId ثابت (وليس currentUid)
      expect(fakeDataSource.lastGetDocId, 'Lcjp7FoCPAo0U3yqqRmm');
    });

    test('throws when document does not exist', () async {
      final missingDoc = await fakeFirestore
          .collection(AppKeys.userInfo)
          .doc('missing')
          .get();
      fakeDataSource.documentToReturn = missingDoc;

      expect(
            () => repository.getInfo(),
        throwsA(isA<Exception>()),
      );
    });

    test('returns UserModel from converter', () async {
      await fakeFirestore.collection(AppKeys.userInfo).doc(
          'Lcjp7FoCPAo0U3yqqRmm').set({
        'firstName': 'Ali',
        'lastName': 'Ahmed',
        'userPhone': '0123',
        'userLocation': 'Cairo',
      });
      final doc = await fakeFirestore
          .collection(AppKeys.userInfo)
          .doc('Lcjp7FoCPAo0U3yqqRmm')
          .get();
      fakeDataSource.documentToReturn = doc;

      final result = await repository.getInfo();

      expect(result, isA<UserModel>());
      expect(result.firstName, 'Ali');
    });
  });

  group('sendOrdersToDatabase', () {
    test('throws ValidationException when userInfo is null', () async {
      expect(
            () =>
            repository.sendOrdersToDatabase(
              userInfo: null,
              shoppingList: [order1],
            ),
        throwsA(isA<ValidationException>()),
      );
    });

    test('calls setData with processingOrders and currentUid', () async {
      final userInfo = UserModel(
        firstName: 'Ali',
        lastName: 'Ahmed',
        userPhone: '0123',
        userLocation: 'Cairo',
      );

      await repository.sendOrdersToDatabase(
        userInfo: userInfo,
        shoppingList: [order1, order2],
      );

      expect(fakeDataSource.setDataCallCount, 1);
      expect(fakeDataSource.lastSetCollectionPath, 'processingOrders');
      expect(fakeDataSource.lastSetDocId, 'user-123');
    });

    test(
        'includes correct userName, userPhone, userLocation in data', () async {
      final userInfo = UserModel(
        firstName: 'Ali',
        lastName: 'Ahmed',
        userPhone: '0123',
        userLocation: 'Cairo',
      );

      await repository.sendOrdersToDatabase(
        userInfo: userInfo,
        shoppingList: [order1],
      );

      final data = fakeDataSource.lastSetData!;
      expect(data['userName'], 'Ali Ahmed');
      expect(data['userPhone'], '0123');
      expect(data['userLocation'], 'Cairo');
    });

    test('includes shoppingList in data', () async {
      final userInfo = UserModel(
        firstName: 'Ali',
        lastName: 'Ahmed',
        userPhone: '0123',
        userLocation: 'Cairo',
      );

      await repository.sendOrdersToDatabase(
        userInfo: userInfo,
        shoppingList: [order1, order2],
      );

      final data = fakeDataSource.lastSetData!;
      expect(data['shoppingList'], isA<List>());
      expect(data['shoppingList'].length, 2);
    });

    test('propagates errors from setData', () async {
      fakeDataSource.setDataError = Exception('write failed');
      final userInfo = UserModel(
        firstName: 'Ali',
        lastName: 'Ahmed',
        userPhone: '0123',
        userLocation: 'Cairo',
      );

      expect(
            () =>
            repository.sendOrdersToDatabase(
              userInfo: userInfo,
              shoppingList: [order1],
            ),
        throwsA(isA<Exception>()),
      );
    });
  });
}