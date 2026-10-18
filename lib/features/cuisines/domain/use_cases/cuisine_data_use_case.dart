import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:international_cuisine/core/data/models/paginated_result.dart';
import 'package:international_cuisine/features/cuisines/data/models/data_model.dart';
import 'package:international_cuisine/features/cuisines/domain/repositories/cuisine_data_repository.dart';


class CuisineDataUseCase {
  CuisineDataRepository _repository;

  CuisineDataUseCase({
    required CuisineDataRepository repository
  })
      : _repository = repository;

  Future<PaginatedResult> getDataExecute(String collectionPath,
      DocumentSnapshot? lastDocument) async {
    final result = await _repository.getPaginatedData(
        collectionPath: collectionPath,
        lastDocument: lastDocument
    );
    return result;
  }

  Future<List<DataModel>> getDataSearchExecute({
    required String collectionPath,
    required String query,
  }) async {
    return await _repository.searchByPartialMatch(
        collectionPath: collectionPath, query: query);
  }

  Future<void> updateRatingExecute({
    required String collectionId,
    required String index,
    required int rating
  }) async {
    await _repository.updateRating(
        collectionId: collectionId, index: index, rating: rating);
  }
}