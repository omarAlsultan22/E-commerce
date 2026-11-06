import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:international_cuisine/core/domain/data_sources/remote/firestore_service.dart';


class FakeFirestoreService implements FirestoreService {
  // ===== addData =====
  String addDataResult = 'generated-id';
  int addDataCallCount = 0;
  String? lastAddCollectionPath;
  Map<String, dynamic>? lastAddData;
  Object? addDataError;

  @override
  Future<String> addData({
    required String collectionPath,
    required Map<String, dynamic> data,
  }) async {
    addDataCallCount++;
    lastAddCollectionPath = collectionPath;
    lastAddData = data;
    if (addDataError != null) throw addDataError!;
    return addDataResult;
  }

  // ===== setData =====
  int setDataCallCount = 0;
  String? lastSetDocId;
  String? lastSetCollectionPath;
  Map<String, dynamic>? lastSetData;
  Object? setDataError;

  @override
  Future<void> setData({
    required String collectionPath,
    required String? docId,
    required Map<String, dynamic> data,
  }) async {
    setDataCallCount++;
    lastSetDocId = docId;
    lastSetCollectionPath = collectionPath;
    lastSetData = data;
    if (setDataError != null) throw setDataError!;
  }

  // ===== getDocument =====
  DocumentSnapshot<Map<String, dynamic>>? documentToReturn;
  int getDocumentCallCount = 0;
  String? lastGetDocId;
  String? lastGetCollectionPath;
  Object? getDocumentError;

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument({
    required String collectionPath,
    required String? docId,
  }) async {
    getDocumentCallCount++;
    lastGetDocId = docId;
    lastGetCollectionPath = collectionPath;
    if (getDocumentError != null) throw getDocumentError!;
    return documentToReturn!;
  }

  // ===== getSupCollection =====
  QuerySnapshot<Map<String, dynamic>>? collectionToReturn;
  int getSupCollectionCallCount = 0;
  String? lastGetSupCollectionPath;
  Object? getSupCollectionError;

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> getSupCollection({
    required String collectionPath,
  }) async {
    getSupCollectionCallCount++;
    lastGetSupCollectionPath = collectionPath;
    if (getSupCollectionError != null) throw getSupCollectionError!;
    return collectionToReturn!;
  }

  // ===== getSubCollection =====
  Query<Map<String, dynamic>>? subCollectionQueryToReturn;
  int getSubCollectionCallCount = 0;
  String? lastSubDocId;
  String? lastSubCollectionPath;
  String? lastSubSuperCollectionPath;

  @override
  Query<Map<String, dynamic>> getSubCollection({
    required String docId,
    required String subCollectionPath,
    required String superCollectionPath,
  }) {
    getSubCollectionCallCount++;
    lastSubDocId = docId;
    lastSubCollectionPath = subCollectionPath;
    lastSubSuperCollectionPath = superCollectionPath;
    return subCollectionQueryToReturn!;
  }

  // ===== updateDocument =====
  int updateDocumentCallCount = 0;
  String? lastUpdateDocId;
  String? lastUpdateCollectionPath;
  Map<String, dynamic>? lastUpdateData;
  Object? updateDocumentError;

  @override
  Future<void> updateDocument({
    required String collectionPath,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    updateDocumentCallCount++;
    lastUpdateDocId = docId;
    lastUpdateCollectionPath = collectionPath;
    lastUpdateData = data;
    if (updateDocumentError != null) throw updateDocumentError!;
  }

  // ===== deleteDocument =====
  int deleteDocumentCallCount = 0;
  String? lastDeleteDocId;
  String? lastDeleteCollectionPath;
  Object? deleteDocumentError;

  @override
  Future<void> deleteDocument({
    required String collectionPath,
    required String docId,
  }) async {
    deleteDocumentCallCount++;
    lastDeleteDocId = docId;
    lastDeleteCollectionPath = collectionPath;
    if (deleteDocumentError != null) throw deleteDocumentError!;
  }

  // ===== streamDocument =====
  Stream<DocumentSnapshot<Map<String, dynamic>>>? documentStream;
  int streamDocumentCallCount = 0;
  String? lastStreamDocId;
  String? lastStreamDocCollectionPath;

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamDocument({
    required String collectionPath,
    required String docId,
  }) {
    streamDocumentCallCount++;
    lastStreamDocId = docId;
    lastStreamDocCollectionPath = collectionPath;
    return documentStream!;
  }

  // ===== streamCollection =====
  Stream<QuerySnapshot<Map<String, dynamic>>>? collectionStream;
  int streamCollectionCallCount = 0;
  String? lastStreamCollectionPath;

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> streamCollection({
    required String collectionPath,
  }) {
    streamCollectionCallCount++;
    lastStreamCollectionPath = collectionPath;
    return collectionStream!;
  }
}