import 'package:flutter_test/flutter_test.dart';
import '../../../../fakes/fake_cuisine_data_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:international_cuisine/core/data/models/paginated_result.dart';
import 'package:international_cuisine/features/cuisines/data/models/data_model.dart';
import 'package:international_cuisine/features/cuisines/domain/use_cases/cuisine_data_use_case.dart';


void main() {
  late FakeCuisineDataRepository fakeRepo;
  late CuisineDataUseCase useCase;
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    fakeRepo = FakeCuisineDataRepository();
    fakeFirestore = FakeFirebaseFirestore();
    useCase = CuisineDataUseCase(repository: fakeRepo);
  });

  group('getDataExecute', () {
    test('passes collectionPath and lastDocument to repository', () async {
      final doc = await fakeFirestore.collection('x').doc('d1').get();

      await useCase.getDataExecute('cuisines', doc);

      expect(fakeRepo.getPaginatedDataCallCount, 1);
      expect(fakeRepo.lastCollectionPath, 'cuisines');
      expect(fakeRepo.lastLastDocument, same(doc));
    });

    test('passes null lastDocument correctly', () async {
      await useCase.getDataExecute('cuisines', null);

      expect(fakeRepo.lastLastDocument, isNull);
    });

    test('returns result from repository', () async {
      final expected = PaginatedResult(
        dataList: [],
        lastDocument: null,
        hasMoreData: true,
      );
      fakeRepo.getPaginatedDataResult = expected;

      final result = await useCase.getDataExecute('cuisines', null);

      expect(result, same(expected));
    });

    test('propagates errors from repository', () async {
      fakeRepo.getPaginatedDataError = Exception('fetch failed');

      expect(
            () => useCase.getDataExecute('cuisines', null),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('getDataSearchExecute', () {
    test('passes collectionPath and query to repository', () async {
      await useCase.getDataSearchExecute(
        collectionPath: 'cuisines',
        query: 'pizza',
      );

      expect(fakeRepo.searchCallCount, 1);
      expect(fakeRepo.lastSearchCollectionPath, 'cuisines');
      expect(fakeRepo.lastSearchQuery, 'pizza');
    });

    test('returns search results from repository', () async {
      final expected = [
        DataModel(orderName: 'Pizza', orderPrice: 10),
        DataModel(orderName: 'Burger', orderPrice: 20),
      ];
      fakeRepo.searchResult = expected;

      final result = await useCase.getDataSearchExecute(
        collectionPath: 'cuisines',
        query: 'pizza',
      );

      expect(result, same(expected));
    });

    test('propagates errors from repository', () async {
      fakeRepo.searchError = Exception('search failed');

      expect(
            () => useCase.getDataSearchExecute(
          collectionPath: 'cuisines',
          query: 'pizza',
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('updateRatingExecute', () {
    test('passes collectionId, index, and rating to repository', () async {
      await useCase.updateRatingExecute(
        collectionId: 'cuisines',
        index: '1',
        rating: 5,
      );

      expect(fakeRepo.updateRatingCallCount, 1);
      expect(fakeRepo.lastUpdateCollectionId, 'cuisines');
      expect(fakeRepo.lastUpdateIndex, '1');
      expect(fakeRepo.lastUpdateRating, 5);
    });

    test('propagates errors from repository', () async {
      fakeRepo.updateRatingError = Exception('update failed');

      expect(
            () => useCase.updateRatingExecute(
          collectionId: 'cuisines',
          index: '1',
          rating: 5,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}