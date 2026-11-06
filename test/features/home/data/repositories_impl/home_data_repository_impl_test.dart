import 'package:flutter_test/flutter_test.dart';
import '../../../../fakes/fake_firestore_service.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:international_cuisine/features/home/domain/repositories/home_data_repository.dart';
import 'package:international_cuisine/features/home/data/repositories_impl/home_data_repository_impl.dart';


void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FakeFirestoreService fakeDataSource;
  late HomeDataRepository repository;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    fakeDataSource = FakeFirestoreService();
    repository = HomeDataRepositoryImpl(dataSource: fakeDataSource);
  });

  group('getData', () {
    test('calls getSupCollection with "homeData" path', () async {
      final snapshot = await fakeFirestore.collection('homeData').get();
      fakeDataSource.collectionToReturn = snapshot;

      await repository.getData();

      expect(fakeDataSource.getSupCollectionCallCount, 1);
      expect(fakeDataSource.lastGetSupCollectionPath, 'homeData');
    });

    test('returns empty list when collection is empty', () async {
      final snapshot = await fakeFirestore.collection('homeData').get();
      fakeDataSource.collectionToReturn = snapshot;

      final result = await repository.getData();

      expect(result, isEmpty);
    });

    test('returns converted HomeDataModel list', () async {
      await fakeFirestore.collection('homeData').doc('1').set({
        'title': 'Pizza',
        'imageData': 'pizza.jpg',
      });
      await fakeFirestore.collection('homeData').doc('2').set({
        'title': 'Burger',
        'imageData': 'burger.jpg',
      });

      final snapshot = await fakeFirestore.collection('homeData').get();
      fakeDataSource.collectionToReturn = snapshot;

      final result = await repository.getData();

      expect(result.length, 2);
      expect(result[0].title, 'Pizza');
      expect(result[0].image, 'pizza.jpg');
      expect(result[1].title, 'Burger');
      expect(result[1].image, 'burger.jpg');
    });

    test('uses default values when fields are missing', () async {
      await fakeFirestore.collection('homeData').doc('1').set({});

      final snapshot = await fakeFirestore.collection('homeData').get();
      fakeDataSource.collectionToReturn = snapshot;

      final result = await repository.getData();

      expect(result.length, 1);
      expect(result.first.title, '');
      expect(result.first.image, '');
    });

    test('propagates errors from getSupCollection', () async {
      fakeDataSource.getSupCollectionError = Exception('fetch failed');

      expect(
            () => repository.getData(),
        throwsA(isA<Exception>()),
      );
    });
  });
}