import 'package:international_cuisine/features/user_info/data/repositories_impl/user_info_repository_impl.dart';
import 'package:international_cuisine/features/user_info/domain/repositories/user_info_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../fakes/mock_session_service.dart';
import '../../../../fakes/fake_firestore_service.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:international_cuisine/core/constants/app_keys.dart';
import 'package:international_cuisine/core/data/models/user_model.dart';


void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FakeFirestoreService fakeDataSource;
  late MockSessionService mockSession;
  late UserInfoRepository repository;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    fakeDataSource = FakeFirestoreService();
    mockSession = MockSessionService();
    when(() => mockSession.currentUid).thenReturn('user-123');
    repository = UserInfoRepositoryImpl(
      dataSource: fakeDataSource,
      sessionService: mockSession,
    );
  });

  group('getInfo', () {
    test('calls getDocument with AppKeys.userInfo and currentUid', () async {
      await fakeFirestore.collection(AppKeys.userInfo).doc('user-123').set({
        'firstName': 'Ali',
        'lastName': 'Ahmed',
        'userPhone': '0123',
        'userLocation': 'Cairo',
      });
      final doc = await fakeFirestore
          .collection(AppKeys.userInfo)
          .doc('user-123')
          .get();
      fakeDataSource.documentToReturn = doc;

      await repository.getInfo();

      expect(fakeDataSource.getDocumentCallCount, 1);
      expect(fakeDataSource.lastGetCollectionPath, AppKeys.userInfo);
      expect(fakeDataSource.lastGetDocId, 'user-123');
    });

    test('returns UserModel from document snapshot', () async {
      await fakeFirestore.collection(AppKeys.userInfo).doc('user-123').set({
        'firstName': 'Ali',
        'lastName': 'Ahmed',
        'userPhone': '0123',
        'userLocation': 'Cairo',
      });
      final doc = await fakeFirestore
          .collection(AppKeys.userInfo)
          .doc('user-123')
          .get();
      fakeDataSource.documentToReturn = doc;

      final result = await repository.getInfo();

      expect(result, isA<UserModel>());
      expect(result.firstName, 'Ali');
      expect(result.lastName, 'Ahmed');
      expect(result.userPhone, '0123');
      expect(result.userLocation, 'Cairo');
    });

    test('propagates errors from getDocument', () async {
      fakeDataSource.getDocumentError = Exception('read failed');

      expect(
            () => repository.getInfo(),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('updateInfo', () {
    test('calls updateDocument with AppKeys.userInfo and currentUid',
            () async {
          await repository.updateInfo(
            firstName: 'Ali',
            lastName: 'Ahmed',
            userPhone: '0123',
            userLocation: 'Cairo',
          );

          expect(fakeDataSource.updateDocumentCallCount, 1);
          expect(fakeDataSource.lastUpdateCollectionPath, AppKeys.userInfo);
          expect(fakeDataSource.lastUpdateDocId, 'user-123');
        });

    test('passes correct userModel data to updateDocument', () async {
      await repository.updateInfo(
        firstName: 'Ali',
        lastName: 'Ahmed',
        userPhone: '0123',
        userLocation: 'Cairo',
      );

      final data = fakeDataSource.lastUpdateData!;
      expect(data['firstName'], 'Ali');
      expect(data['lastName'], 'Ahmed');
      expect(data['userPhone'], '0123');
      expect(data['userLocation'], 'Cairo');
      expect(data['fullName'], 'Ali Ahmed');  // ← fullName من toJson
    });

    test('uses currentUid from SessionService', () async {
      when(() => mockSession.currentUid).thenReturn('custom-uid-456');

      await repository.updateInfo(
        firstName: 'Sara',
        lastName: 'Mohamed',
        userPhone: '9999',
        userLocation: 'Alexandria',
      );

      expect(fakeDataSource.lastUpdateDocId, 'custom-uid-456');
    });

    test('propagates errors from updateDocument', () async {
      fakeDataSource.updateDocumentError = Exception('update failed');

      expect(
            () => repository.updateInfo(
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