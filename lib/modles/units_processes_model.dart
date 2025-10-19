abstract class UnitsProcessesModel {

  void clearSearch();

  Future<void> getData();

  Future<void> updateData({
    required String collectionId,
    required String index,
    required int rating
  });

  Future<void> getDataSearch(String searchText);
}
