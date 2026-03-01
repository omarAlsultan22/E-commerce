import '../models/data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/data/models/paginated_result.dart';
import '../../presentation/utils/helpers/cuisine_data_converter.dart';
import 'package:international_cuisine/features/cuisines/domain/repositories/cuisine_data_repository.dart';


class FirestoreCuisineDataRepository implements CuisineDataRepository {
  final FirebaseFirestore _firestore;

  FirestoreCuisineDataRepository({
    required FirebaseFirestore firestore
  }) : _firestore = firestore;

  static const orderName = 'countriesData';
  static const collectionId = 'countriesData';
  static const docId = 'L8nSAa05FTdy6I47cOaf';

  @override
  Future<PaginatedResult> getPaginatedData({
    required String collectionPath,
    required DocumentSnapshot? lastDocument,
    int pageSize = 5,
  }) async {
    Query query = _firestore.collection(collectionId)
        .doc(docId)
        .collection(collectionPath);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }
    try {
      final querySnapshot = await query.limit(pageSize).get();


      if (querySnapshot.docs.isEmpty) {
        return PaginatedResult(
          dataList: [],
          lastDocument: null,
          hasMoreData: false,
        );
      }

      final data = DataModelConverter
          .fromQuerySnapshot(querySnapshot)
          .data;

      return PaginatedResult(
        dataList: data,
        lastDocument: querySnapshot.docs.last,
        hasMoreData: data.length == pageSize,
      );
    }
    catch (e) {
      rethrow;
    }
  }


  @override
  Future<List<DataModel>> searchByPartialMatch({
    required String collectionPath,
    required String query,
  }) async {
    final normalizedQuery = query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      return [];
    }

    var firestoreQuery = _firestore
        .collection(collectionId)
        .doc(docId)
        .collection(collectionPath)
        .where(orderName, isGreaterThanOrEqualTo: normalizedQuery)
        .where(orderName, isLessThanOrEqualTo: '$normalizedQuery\uf8ff');

    try {
      final snapshot = await firestoreQuery.get();

      return snapshot.docs
          .where((doc) {
        final data = doc.data();
        final fullName = data[orderName]?.toString().toLowerCase() ?? '';
        return fullName.contains(normalizedQuery);
      }).map((doc) {
        final data = doc.data();
        return DataModel.fromFirestore(data);
      }).toList();
    }
    catch (e) {
      rethrow;
    }
  }


  @override
  Future<void> updateRating({
    required String collectionId,
    required String index,
    required int rating
  }) async {
    try {
      return await _firestore.collection(collectionId).doc(index).update(
          {'rating': rating});
    }
    catch (e) {
      rethrow;
    }
  }
}

