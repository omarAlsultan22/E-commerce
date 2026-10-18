import 'package:cloud_firestore/cloud_firestore.dart';


abstract class FirestoreService {
  Future<String> addData({
    required String collectionPath,
    required Map<String, dynamic> data,
  });

  Future<void> setData({
    required String collectionPath,
    required String? docId,
    required Map<String, dynamic> data,
  });

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument({
    required String collectionPath,
    required String? docId,
  });

  Future<QuerySnapshot<Map<String, dynamic>>> getSupCollection({
    required String collectionPath,
  });

  Query<Map<String, dynamic>> getSubCollection({
    required String docId,
    required String subCollectionPath,
    required String superCollectionPath,
  });

  Future<void> updateDocument({
    required String collectionPath,
    required String docId,
    required Map<String, dynamic> data,
  });

  Future<void> deleteDocument({
    required String collectionPath,
    required String docId,
  });

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamDocument({
    required String collectionPath,
    required String docId,
  });

  Stream<QuerySnapshot<Map<String, dynamic>>> streamCollection({
    required String collectionPath,
  });
}