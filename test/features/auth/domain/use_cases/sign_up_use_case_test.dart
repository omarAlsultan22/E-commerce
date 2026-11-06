import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../fakes/fake_cache_helper.dart';
import '../../../../fakes/fake_auth_repository.dart';
import '../../../../fakes/fake_sign_up_repository.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:international_cuisine/features/auth/domain/use_cases/sign_up_use_case.dart';


void main() {
  late FakeAuthRepository fakeAuth;
  late FakeSignUpRepository fakeSignUp;
  late FakeCacheHelper fakeCache;
  late SignUpUseCase useCase;
  late UserCredential validCredential;

  setUp(() async {
    fakeAuth = FakeAuthRepository();
    fakeSignUp = FakeSignUpRepository();
    fakeCache = FakeCacheHelper();
    useCase = SignUpUseCase(
      authRepository: fakeAuth,
      signUpRepository: fakeSignUp,
      cacheHelper: fakeCache,
    );

    final mockAuth = MockFirebaseAuth(
      mockUser: MockUser(uid: 'uid-123', email: 'a@b.com'),
      signedIn: true,
    );
    validCredential = await mockAuth.signInWithEmailAndPassword(
      email: 'a@b.com',
      password: 'p',
    );
  });

  group('signUpExecute', () {
    test('passes credentials to authRepository.signUp', () async {
      fakeAuth.signUpResult = validCredential;

      await useCase.signUpExecute(
        firstName: 'Ali',
        lastName: 'Ahmed',
        userEmail: 'a@b.com',
        userPassword: 'password123',
        userPhone: '0123',
        userLocation: 'Cairo',
      );

      expect(fakeAuth.signUpCallCount, 1);
      expect(fakeAuth.lastSignUpEmail, 'a@b.com');
      expect(fakeAuth.lastSignUpPassword, 'password123');
    });

    test('calls createUserInfo with correct UserModel', () async {
      fakeAuth.signUpResult = validCredential;

      await useCase.signUpExecute(
        firstName: 'Ali',
        lastName: 'Ahmed',
        userEmail: 'a@b.com',
        userPassword: 'p',
        userPhone: '0123',
        userLocation: 'Cairo',
      );

      expect(fakeSignUp.createUserInfoCallCount, 1);
      final userModel = fakeSignUp.lastUserModel!;
      expect(userModel.firstName, 'Ali');
      expect(userModel.lastName, 'Ahmed');
      expect(userModel.userPhone, '0123');
      expect(userModel.userLocation, 'Cairo');
      expect(fakeSignUp.lastUserCredential, same(validCredential));
    });

    test('saves userName to cache as firstName + lastName', () async {
      fakeAuth.signUpResult = validCredential;

      await useCase.signUpExecute(
        firstName: 'Ali',
        lastName: 'Ahmed',
        userEmail: 'a@b.com',
        userPassword: 'p',
        userPhone: '0123',
        userLocation: 'Cairo',
      );

      // 'AliAhmed' — بدون مسافة
      expect(await fakeCache.getString(key: 'userName'), 'AliAhmed');
    });

    test('propagates errors from authRepository.signUp', () async {
      fakeAuth.signUpError = FirebaseAuthException(code: 'email-already-in-use');

      expect(
            () => useCase.signUpExecute(
          firstName: 'Ali',
          lastName: 'Ahmed',
          userEmail: 'a@b.com',
          userPassword: 'p',
          userPhone: '0123',
          userLocation: 'Cairo',
        ),
        throwsA(isA<FirebaseAuthException>()),
      );

      // createUserInfo لم يُستدعَ
      expect(fakeSignUp.createUserInfoCallCount, 0);
    });

    test('propagates errors from createUserInfo', () async {
      fakeAuth.signUpResult = validCredential;
      fakeSignUp.createUserInfoError = Exception('save failed');

      expect(
            () => useCase.signUpExecute(
          firstName: 'Ali',
          lastName: 'Ahmed',
          userEmail: 'a@b.com',
          userPassword: 'p',
          userPhone: '0123',
          userLocation: 'Cairo',
        ),
        throwsA(isA<Exception>()),
      );

      // cache لم يُكتب
      expect(await fakeCache.getString(key: 'userName'), '');
    });
  });
}