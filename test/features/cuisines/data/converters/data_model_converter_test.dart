import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:international_cuisine/features/cuisines/data/converters/cuisine_data_converter.dart';


void main() {
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
  });

  group('DataModelConverter.fromQuerySnapshot', () {
    test('converts empty snapshot to empty list', () async {
      final snapshot = await fakeFirestore.collection('items').get();

      final converter = DataModelConverter.fromQuerySnapshot(snapshot);

      expect(converter.data, isEmpty);
    });

    test('converts single document with correct fields', () async {
      await fakeFirestore.collection('items').doc('1').set({
        'orderName': 'Pizza',
        'orderImage': 'pizza.jpg',
        'orderPrice': 10,
        'rating': 5,
      });

      final snapshot = await fakeFirestore.collection('items').get();
      final converter = DataModelConverter.fromQuerySnapshot(snapshot);

      expect(converter.data.length, 1);
      expect(converter.data.first.orderName, 'Pizza');
      expect(converter.data.first.orderImage, 'pizza.jpg');
      expect(converter.data.first.orderPrice, 10);
      expect(converter.data.first.rating, 5);
    });

    test('converts multiple documents', () async {
      await fakeFirestore.collection('items').doc('1').set({
        'orderName': 'Pizza',
        'orderPrice': 10,
      });
      await fakeFirestore.collection('items').doc('2').set({
        'orderName': 'Burger',
        'orderPrice': 20,
      });
      await fakeFirestore.collection('items').doc('3').set({
        'orderName': 'Pasta',
        'orderPrice': 15,
      });

      final snapshot = await fakeFirestore.collection('items').get();
      final converter = DataModelConverter.fromQuerySnapshot(snapshot);

      expect(converter.data.length, 3);
      expect(converter.data[0].orderName, 'Pizza');
      expect(converter.data[1].orderName, 'Burger');
      expect(converter.data[2].orderName, 'Pasta');
    });

    test('uses default rating 4 when rating is missing', () async {
      await fakeFirestore.collection('items').doc('1').set({
        'orderName': 'Pizza',
        'orderPrice': 10,
        // لا rating
      });

      final snapshot = await fakeFirestore.collection('items').get();
      final converter = DataModelConverter.fromQuerySnapshot(snapshot);

      expect(converter.data.first.rating, 4);  // ← افتراضي
    });

    test('uses default values when fields are missing', () async {
      await fakeFirestore.collection('items').doc('1').set({});

      final snapshot = await fakeFirestore.collection('items').get();
      final converter = DataModelConverter.fromQuerySnapshot(snapshot);

      expect(converter.data.first.orderName, '');
      expect(converter.data.first.orderImage, '');
      expect(converter.data.first.orderPrice, '');
      expect(converter.data.first.rating, 4);
    });
  });
}