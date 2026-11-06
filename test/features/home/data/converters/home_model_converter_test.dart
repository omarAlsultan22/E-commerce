import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:international_cuisine/features/home/data/converters/home_data_converter.dart';


void main() {
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
  });

  group('HomeModelConverter.fromQuerySnapshot', () {
    test('converts empty snapshot to empty list', () async {
      final snapshot = await fakeFirestore.collection('homeData').get();

      final converter = HomeModelConverter.fromQuerySnapshot(snapshot);

      expect(converter.data, isEmpty);
    });

    test('converts single document', () async {
      await fakeFirestore.collection('homeData').doc('1').set({
        'title': 'Pizza',
        'imageData': 'pizza.jpg',
      });

      final snapshot = await fakeFirestore.collection('homeData').get();
      final converter = HomeModelConverter.fromQuerySnapshot(snapshot);

      expect(converter.data.length, 1);
      expect(converter.data.first.title, 'Pizza');
      expect(converter.data.first.image, 'pizza.jpg');
    });

    test('converts multiple documents preserving order', () async {
      await fakeFirestore.collection('homeData').doc('1').set({
        'title': 'First',
        'imageData': 'first.jpg',
      });
      await fakeFirestore.collection('homeData').doc('2').set({
        'title': 'Second',
        'imageData': 'second.jpg',
      });
      await fakeFirestore.collection('homeData').doc('3').set({
        'title': 'Third',
        'imageData': 'third.jpg',
      });

      final snapshot = await fakeFirestore.collection('homeData').get();
      final converter = HomeModelConverter.fromQuerySnapshot(snapshot);

      expect(converter.data.length, 3);
      expect(converter.data[0].title, 'First');
      expect(converter.data[1].title, 'Second');
      expect(converter.data[2].title, 'Third');
    });

    test('uses default values when fields are missing', () async {
      await fakeFirestore.collection('homeData').doc('1').set({});

      final snapshot = await fakeFirestore.collection('homeData').get();
      final converter = HomeModelConverter.fromQuerySnapshot(snapshot);

      expect(converter.data.length, 1);
      expect(converter.data.first.title, '');
      expect(converter.data.first.image, '');
    });

    test('handles document with only title', () async {
      await fakeFirestore.collection('homeData').doc('1').set({
        'title': 'Only Title',
      });

      final snapshot = await fakeFirestore.collection('homeData').get();
      final converter = HomeModelConverter.fromQuerySnapshot(snapshot);

      expect(converter.data.first.title, 'Only Title');
      expect(converter.data.first.image, '');
    });
  });
}