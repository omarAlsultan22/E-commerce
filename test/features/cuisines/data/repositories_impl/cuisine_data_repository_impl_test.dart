import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:international_cuisine/core/data/data_sources/remote/firestore_service_impl.dart';
import 'package:international_cuisine/features/cuisines/domain/repositories/cuisine_data_repository.dart';
import 'package:international_cuisine/features/cuisines/data/repositories_impl/cuisine_data_repository_impl.dart';


void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreServiceImpl fakeDataSource;
  late CuisineDataRepository repository;

  setUp(() async {
    fakeFirestore = FakeFirebaseFirestore();
    fakeDataSource = FirestoreServiceImpl(firestore: fakeFirestore);
    repository = CuisineDataRepositoryImpl(dataSource: fakeDataSource);

    final base = fakeFirestore
        .collection('countriesData')
        .doc('L8nSAa05FTdy6I47cOaf')
        .collection('cuisines');

    for (int i = 1; i <= 10; i++) {
      await base.doc('$i').set({
        'orderName': 'Cuisine $i',
        'orderImage': 'img$i.jpg',
        'orderPrice': i * 10,
      });
    }
  });

  group('getPaginatedData', () {
    test('returns first page with pageSize items', () async {
      final result = await repository.getPaginatedData(
        collectionPath: 'cuisines',
        lastDocument: null,
        pageSize: 5,
      );

      expect(result.dataList.length, 5);
      expect(result.lastDocument, isNotNull);
      expect(result.hasMoreData, true);
    });

    test('returns empty result when no documents', () async {
      final result = await repository.getPaginatedData(
        collectionPath: 'empty',
        lastDocument: null,
        pageSize: 5,
      );

      expect(result.dataList, isEmpty);
      expect(result.lastDocument, isNull);
      expect(result.hasMoreData, false);
    });

    test('hasMoreData is false when fewer than pageSize', () async {
      final result = await repository.getPaginatedData(
        collectionPath: 'cuisines',
        lastDocument: null,
        pageSize: 20,
      );

      expect(result.dataList.length, 10);
      expect(result.hasMoreData, false);
    });

    test('uses startAfterDocument for pagination', () async {
      final firstPage = await repository.getPaginatedData(
        collectionPath: 'cuisines',
        lastDocument: null,
        pageSize: 5,
      );

      final secondPage = await repository.getPaginatedData(
        collectionPath: 'cuisines',
        lastDocument: firstPage.lastDocument,
        pageSize: 5,
      );

      expect(secondPage.dataList.length, 5);
      expect(
        secondPage.dataList.first.orderName,
        isNot(equals(firstPage.dataList.first.orderName)),
      );
    });
  });

  group('searchByPartialMatch', () {
    test('returns empty list for empty query', () async {
      final result = await repository.searchByPartialMatch(
        collectionPath: 'cuisines',
        query: '   ',
      );

      expect(result, isEmpty);
    });

    test('returns matching results', () async {
      final result = await repository.searchByPartialMatch(
        collectionPath: 'cuisines',
        query: 'Cuisine 1',
      );

      expect(result.length, greaterThan(0));
    });

    test('trims and lowercases query', () async {
      final result = await repository.searchByPartialMatch(
        collectionPath: 'cuisines',
        query: '  CUISINE 1  ',
      );

      expect(result.length, greaterThan(0));
    });

    test('returns empty list when no match', () async {
      final result = await repository.searchByPartialMatch(
        collectionPath: 'cuisines',
        query: 'zzzzzz',
      );

      expect(result, isEmpty);
    });
  });

  group('updateRating', () {
    test('uses literal "collectionId" (documents bug)', () async {
      await fakeFirestore
          .collection('countriesData')
          .doc('L8nSAa05FTdy6I47cOaf')
          .collection('cuisines')
          .doc('1')
          .set({'orderName': 'Cuisine 1', 'rating': 0});

      await repository.updateRating(
        collectionId: 'cuisines',
        index: '1',
        rating: 5,
      );

      // ← bug: collectionPath = 'collectionId' (وليس parameter)
      final doc = await fakeFirestore
          .collection('countriesData')
          .doc('L8nSAa05FTdy6I47cOaf')
          .collection('cuisines')
          .doc('1')
          .get();
      expect(doc.data()?['rating'], 0);  // ← لم يتغير
    });
  });
}