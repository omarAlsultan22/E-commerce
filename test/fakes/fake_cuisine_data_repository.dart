import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:international_cuisine/core/data/models/paginated_result.dart';
import 'package:international_cuisine/features/cuisines/data/models/data_model.dart';
import 'package:international_cuisine/features/cuisines/domain/repositories/cuisine_data_repository.dart';


class FakeCuisineDataRepository implements CuisineDataRepository {
  // ===== getPaginatedData =====
  PaginatedResult getPaginatedDataResult = PaginatedResult(
    dataList: [],
    lastDocument: null,
    hasMoreData: false,
  );
  Object? getPaginatedDataError;
  int getPaginatedDataCallCount = 0;
  String? lastCollectionPath;
  DocumentSnapshot? lastLastDocument;

  @override
  Future<PaginatedResult> getPaginatedData({
    required String collectionPath,
    required DocumentSnapshot? lastDocument,
    int pageSize = 5,
  }) async {
    getPaginatedDataCallCount++;
    lastCollectionPath = collectionPath;
    lastLastDocument = lastDocument;
    if (getPaginatedDataError != null) throw getPaginatedDataError!;
    return getPaginatedDataResult;
  }

  // ===== searchByPartialMatch =====
  List<DataModel> searchResult = [];
  Object? searchError;
  int searchCallCount = 0;
  String? lastSearchCollectionPath;
  String? lastSearchQuery;

  @override
  Future<List<DataModel>> searchByPartialMatch({
    required String collectionPath,
    required String query,
  }) async {
    searchCallCount++;
    lastSearchCollectionPath = collectionPath;
    lastSearchQuery = query;
    if (searchError != null) throw searchError!;
    return searchResult;
  }

  // ===== updateRating =====
  int updateRatingCallCount = 0;
  String? lastUpdateCollectionId;
  String? lastUpdateIndex;
  int? lastUpdateRating;
  Object? updateRatingError;

  @override
  Future<void> updateRating({
    required String collectionId,
    required String index,
    required int rating,
  }) async {
    updateRatingCallCount++;
    lastUpdateCollectionId = collectionId;
    lastUpdateIndex = index;
    lastUpdateRating = rating;
    if (updateRatingError != null) throw updateRatingError!;
  }
}