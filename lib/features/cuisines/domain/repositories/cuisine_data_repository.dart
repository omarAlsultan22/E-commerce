import '../../data/models/data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/data/models/paginated_result.dart';


abstract class CuisineDataRepository {

  Future<PaginatedResult<DataModel>> getPaginatedData({
    required String collectionPath,
    required DocumentSnapshot? lastDocument,
    int pageSize = 5,
  });

  Future<List<DataModel>> searchByPartialMatch({
    required String collectionPath,
    required String query,
  });

  Future<void> updateRating({
    required String collectionId,
    required String index,
    required int rating
  });
}