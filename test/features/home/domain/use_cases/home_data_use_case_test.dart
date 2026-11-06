import 'package:flutter_test/flutter_test.dart';
import '../../../../fakes/fake_home_data_repository.dart';
import 'package:international_cuisine/features/home/data/models/home_model.dart';
import 'package:international_cuisine/core/errors/exceptions/firebase_exception.dart';
import 'package:international_cuisine/features/home/domain/use_cases/home_data_use_case.dart';


void main() {
  late FakeHomeDataRepository fakeRepo;
  late HomeDataUseCase useCase;

  setUp(() {
    fakeRepo = FakeHomeDataRepository();
    useCase = HomeDataUseCase(userInfoRepository: fakeRepo);
  });

  group('getDataExecute', () {
    test('returns data when repository returns non-empty list', () async {
      final expected = [
        HomeDataModel(image: 'pizza.jpg', title: 'Pizza'),
        HomeDataModel(image: 'burger.jpg', title: 'Burger'),
      ];
      fakeRepo.getDataResult = expected;

      final result = await useCase.getDataExecute();

      expect(result, same(expected));
      expect(fakeRepo.getDataCallCount, 1);
    });

    test('throws FirebaseAppException when repository returns empty list',
            () async {
          fakeRepo.getDataResult = [];

          expect(
                () => useCase.getDataExecute(),
            throwsA(isA<FirebaseAppException>()),
          );
        });

    test('throws with message "There is no data"', () async {
      fakeRepo.getDataResult = [];

      expect(
            () => useCase.getDataExecute(),
        throwsA(
          isA<FirebaseAppException>().having(
                (e) => e.message,
            'message',
            'There is no data',
          ),
        ),
      );
    });

    test('propagates errors from repository.getData', () async {
      fakeRepo.getDataError = Exception('fetch failed');

      expect(
            () => useCase.getDataExecute(),
        throwsA(isA<Exception>()),
      );
    });
  });
}