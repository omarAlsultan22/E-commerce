import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:international_cuisine/core/data/data_sources/remote/firestore_service_impl.dart';


void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreServiceImpl service;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    service = FirestoreServiceImpl(firestore: fakeFirestore);
  });

  group('addData', () {
    test('adds data and returns the generated id', () async {
      final id = await service.addData(
        collectionPath: 'users',
        data: {'name': 'Ali'},
      );

      expect(id, isNotEmpty);
      final snapshot = await fakeFirestore.collection('users').doc(id).get();
      expect(snapshot.data()?['name'], 'Ali');
    });

    test('adds multiple documents independently', () async {
      final id1 = await service.addData(
        collectionPath: 'users',
        data: {'name': 'A'},
      );
      final id2 = await service.addData(
        collectionPath: 'users',
        data: {'name': 'B'},
      );

      expect(id1, isNot(id2));
    });
  });

  group('setData', () {
    test('sets data at the given doc id', () async {
      await service.setData(
        collectionPath: 'users',
        docId: 'user-1',
        data: {'name': 'Ali'},
      );

      final snapshot =
      await fakeFirestore.collection('users').doc('user-1').get();
      expect(snapshot.exists, true);
      expect(snapshot.data()?['name'], 'Ali');
    });

    test('overwrites existing document', () async {
      await fakeFirestore
          .collection('users')
          .doc('user-1')
          .set({'name': 'Old', 'age': 20});

      await service.setData(
        collectionPath: 'users',
        docId: 'user-1',
        data: {'name': 'New'},
      );

      final snapshot =
      await fakeFirestore.collection('users').doc('user-1').get();
      expect(snapshot.data(), {'name': 'New'});
    });
  });

  group('getDocument', () {
    test('returns snapshot when it exists', () async {
      await fakeFirestore
          .collection('users')
          .doc('user-1')
          .set({'name': 'Ali'});

      final snapshot = await service.getDocument(
        collectionPath: 'users',
        docId: 'user-1',
      );

      expect(snapshot.exists, true);
      expect(snapshot.data()?['name'], 'Ali');
    });

    test('returns non-existing snapshot when missing', () async {
      final snapshot = await service.getDocument(
        collectionPath: 'users',
        docId: 'missing',
      );

      expect(snapshot.exists, false);
    });
  });

  group('getSupCollection', () {
    test('returns all docs in collection', () async {
      await fakeFirestore.collection('users').doc('u1').set({'name': 'A'});
      await fakeFirestore.collection('users').doc('u2').set({'name': 'B'});

      final result = await service.getSupCollection(collectionPath: 'users');

      expect(result.docs.length, 2);
    });

    test('returns empty snapshot for empty collection', () async {
      final result = await service.getSupCollection(collectionPath: 'empty');

      expect(result.docs, isEmpty);
    });
  });

  group('getSubCollection', () {
    test('returns a Query for the correct subcollection path', () async {
      await fakeFirestore
          .collection('users')
          .doc('user-1')
          .collection('posts')
          .doc('post-1')
          .set({'title': 'Hello'});

      final query = service.getSubCollection(
        docId: 'user-1',
        superCollectionPath: 'users',
        subCollectionPath: 'posts',
      );

      final result = await query.get();
      expect(result.docs.length, 1);
      expect(result.docs.first.data()['title'], 'Hello');
    });

    test('does not include supercollection documents', () async {
      await fakeFirestore
          .collection('users')
          .doc('user-1')
          .set({'name': 'Ali'});

      final query = service.getSubCollection(
        docId: 'user-1',
        superCollectionPath: 'users',
        subCollectionPath: 'posts',
      );

      final result = await query.get();
      expect(result.docs, isEmpty);
    });
  });

  group('updateDocument', () {
    test('updates existing document fields', () async {
      await fakeFirestore
          .collection('users')
          .doc('user-1')
          .set({'name': 'Ali', 'age': 25});

      await service.updateDocument(
        docId: 'user-1',
        collectionPath: 'users',
        data: {'age': 26},
      );

      final snapshot =
      await fakeFirestore.collection('users').doc('user-1').get();
      expect(snapshot.data()?['name'], 'Ali');
      expect(snapshot.data()?['age'], 26);
    });

    test('throws when document does not exist', () async {
      expect(
            () => service.updateDocument(
          docId: 'missing',
          collectionPath: 'users',
          data: {'name': 'X'},
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('deleteDocument', () {
    test('removes the document', () async {
      await fakeFirestore.collection('users').doc('u1').set({'name': 'A'});

      await service.deleteDocument(collectionPath: 'users', docId: 'u1');

      final snapshot = await fakeFirestore.collection('users').doc('u1').get();
      expect(snapshot.exists, false);
    });

    test('completes without error when document is missing', () async {
      await expectLater(
        service.deleteDocument(collectionPath: 'users', docId: 'missing'),
        completes,
      );
    });
  });

  group('streamDocument', () {
    test('emits initial snapshot', () async {
      await fakeFirestore.collection('users').doc('u1').set({'name': 'Ali'});

      final stream = service.streamDocument(
        collectionPath: 'users',
        docId: 'u1',
      );

      final snapshot = await stream.first;
      expect(snapshot.data()?['name'], 'Ali');
    });

    test('emits updated snapshot after update', () async {
      await fakeFirestore.collection('users').doc('u1').set({'name': 'Old'});

      final stream = service.streamDocument(
        collectionPath: 'users',
        docId: 'u1',
      );

      final first = await stream.first;
      expect(first.data()?['name'], 'Old');

      await fakeFirestore
          .collection('users')
          .doc('u1')
          .update({'name': 'New'});

      final second = await stream.first;
      expect(second.data()?['name'], 'New');
    });
  });

  group('streamCollection', () {
    test('emits collection snapshot', () async {
      await fakeFirestore.collection('users').doc('u1').set({'name': 'A'});
      await fakeFirestore.collection('users').doc('u2').set({'name': 'B'});

      final stream = service.streamCollection(collectionPath: 'users');

      final snapshot = await stream.first;
      expect(snapshot.docs.length, 2);
    });

    test('emits empty snapshot for empty collection', () async {
      final stream = service.streamCollection(collectionPath: 'empty');

      final snapshot = await stream.first;
      expect(snapshot.docs, isEmpty);
    });
  });
}