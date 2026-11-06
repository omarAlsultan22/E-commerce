import 'package:flutter_test/flutter_test.dart';
import '../../../../fakes/fake_user_info_repository.dart';
import 'package:international_cuisine/core/data/models/user_model.dart';
import 'package:international_cuisine/features/user_info/domain/use_cases/user_info_use_case.dart';


void main() {
  late UserInfoUseCase useCase;
  late FakeUserInfoRepository fakeRepo;

  setUp(() {
    fakeRepo = FakeUserInfoRepository();
    useCase = UserInfoUseCase(userInfoRepository: fakeRepo);
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

  group('updateInfoExecute', () {
    test('passes all parameters to repository', () async {
      await useCase.updateInfoExecute(
        firstName: 'Ali',
        lastName: 'Ahmed',
        userPhone: '0123',
        userLocation: 'Cairo',
      );

      expect(fakeRepo.updateInfoCallCount, 1);
      expect(fakeRepo.lastFirstName, 'Ali');
      expect(fakeRepo.lastLastName, 'Ahmed');
      expect(fakeRepo.lastUserPhone, '0123');
      expect(fakeRepo.lastUserLocation, 'Cairo');
    });

    test('passes different values correctly', () async {
      await useCase.updateInfoExecute(
        firstName: 'Sara',
        lastName: 'Mohamed',
        userPhone: '9999',
        userLocation: 'Alexandria',
      );

      expect(fakeRepo.lastFirstName, 'Sara');
      expect(fakeRepo.lastLastName, 'Mohamed');
      expect(fakeRepo.lastUserPhone, '9999');
      expect(fakeRepo.lastUserLocation, 'Alexandria');
    });

    test('propagates errors from repository', () async {
      fakeRepo.updateInfoError = Exception('update failed');

      expect(
            () => useCase.updateInfoExecute(
          firstName: 'Ali',
          lastName: 'Ahmed',
          userPhone: '0123',
          userLocation: 'Cairo',
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}