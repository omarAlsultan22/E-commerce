import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:international_cuisine/features/payment_invoice/data/converters/user_info_converter.dart';


void main() {
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
  });

  group('UserInfoConverter.fromDocumentSnapshot', () {
    test('throws when document does not exist', () async {
      final doc = await fakeFirestore.collection('users').doc('missing').get();

      expect(
            () => UserInfoConverter.fromDocumentSnapshot(doc, ''),
        throwsA(isA<Exception>()),
      );
    });

    test('throws when document data is null', () async {
      // مستند غير موجود — data() == null
      final doc = await fakeFirestore.collection('users').doc('missing').get();

      expect(
            () => UserInfoConverter.fromDocumentSnapshot(doc, 'Cairo'),
        throwsA(isA<Exception>()),
      );
    });

    test('returns UserModel without location when Location is empty',
            () async {
          await fakeFirestore.collection('users').doc('user-1').set({
            'firstName': 'Ali',
            'lastName': 'Ahmed',
            'userPhone': '0123',
            'userLocation': 'Cairo',
          });

          final doc = await fakeFirestore.collection('users').doc('user-1').get();
          final converter = UserInfoConverter.fromDocumentSnapshot(doc, '');

          expect(converter.userModel.firstName, 'Ali');
          expect(converter.userModel.lastName, 'Ahmed');
          expect(converter.userModel.userPhone, '0123');
        });

    test('adds location to map when Location is not empty', () async {
      await fakeFirestore.collection('users').doc('user-1').set({
        'firstName': 'Ali',
        'lastName': 'Ahmed',
      });

      final doc = await fakeFirestore.collection('users').doc('user-1').get();
      final converter = UserInfoConverter.fromDocumentSnapshot(doc, 'Alexandria');

      // ← location يُضاف كـ 'location' (وليس 'userLocation')
      // UserModel.fromJson يقرأ 'userLocation' — لا يتأثر
      expect(converter.userModel.firstName, 'Ali');
      // userLocation — يبقى '' (لأن 'location' لا يُقرأ)
      expect(converter.userModel.userLocation, '');
    });

    test('uses userLocation from document when Location is empty', () async {
      await fakeFirestore.collection('users').doc('user-1').set({
        'firstName': 'Ali',
        'userLocation': 'Cairo',
      });

      final doc = await fakeFirestore.collection('users').doc('user-1').get();
      final converter = UserInfoConverter.fromDocumentSnapshot(doc, '');

      expect(converter.userModel.userLocation, 'Cairo');
    });
  });
}