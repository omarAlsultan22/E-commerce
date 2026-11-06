import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../fakes/fake_firestore_service.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:international_cuisine/core/constants/app_keys.dart';
import 'package:international_cuisine/core/data/models/user_model.dart';
import 'package:international_cuisine/features/auth/domain/repositories/sign_up_repository.dart';
import 'package:international_cuisine/features/auth/data/repositories_impl/sign_up_repository_impl.dart';


class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late SignUpRepository repository;
  late UserCredential userCredential;
  late FakeFirestoreService fakeDataSource;

  setUp(() async {
    fakeDataSource = FakeFirestoreService();
    repository = SignUpRepositoryImpl(service: fakeDataSource);

    final mockAuth = MockFirebaseAuth(
      mockUser: MockUser(uid: 'uid-123', email: 'a@b.com'),
      signedIn: true,
    );
    userCredential = await mockAuth.signInWithEmailAndPassword(
      email: 'a@b.com',
      password: 'p',
    );
  });

  group('createUserInfo', () {
    test('calls setData with AppKeys.userInfo and userCredential.uid', () async {
      final userModel = UserModel(
        firstName: 'Ali',
        lastName: 'Ahmed',
        userPhone: '0123456789',
        userLocation: 'Cairo',
      );

      await repository.createUserInfo(
        userModel: userModel,
        userCredential: userCredential,
      );

      expect(fakeDataSource.setDataCallCount, 1);
      expect(fakeDataSource.lastSetCollectionPath, AppKeys.userInfo);
      expect(fakeDataSource.lastSetDocId, 'uid-123');
      expect(fakeDataSource.lastSetData, userModel.toJson());
    });

    test('passes data with correct fields to setData', () async {
      final userModel = UserModel(
        firstName: 'Ali',
        lastName: 'Ahmed',
        userPhone: '0123456789',
        userLocation: 'Cairo',
      );

      await repository.createUserInfo(
        userModel: userModel,
        userCredential: userCredential,
      );

      final data = fakeDataSource.lastSetData!;
      expect(data['firstName'], 'Ali');
      expect(data['lastName'], 'Ahmed');
      expect(data['userPhone'], '0123456789');
      expect(data['userLocation'], 'Cairo');
      expect(data['fullName'], 'Ali Ahmed');  // ← fullName من toJson
      expect(data['createdAt'], isA<FieldValue>());  // ← serverTimestamp
    });

    test('throws TypeError when userCredential.user is null', () async {
      final emptyCredential = MockUserCredential();
      when(() => emptyCredential.user).thenReturn(null);

      final userModel = UserModel(
        firstName: 'Ali',
        lastName: 'Ahmed',
        userPhone: '0123456789',
        userLocation: 'Cairo',
      );

      expect(
            () => repository.createUserInfo(
          userModel: userModel,
          userCredential: emptyCredential,
        ),
        throwsA(isA<TypeError>()),
      );

      expect(fakeDataSource.setDataCallCount, 0);
    });

    test('propagates errors from setData', () async {
      fakeDataSource.setDataError = Exception('write failed');
      final userModel = UserModel(
        firstName: 'Ali',
        lastName: 'Ahmed',
        userPhone: '0123456789',
        userLocation: 'Cairo',
      );

      expect(
            () => repository.createUserInfo(
          userModel: userModel,
          userCredential: userCredential,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}