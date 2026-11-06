import 'package:international_cuisine/features/home/data/models/home_model.dart';
import 'package:international_cuisine/features/home/domain/repositories/home_data_repository.dart';


class FakeHomeDataRepository implements HomeDataRepository {
  List<HomeDataModel> getDataResult = [];
  Object? getDataError;
  int getDataCallCount = 0;

  @override
  Future<List<HomeDataModel>> getData() async {
    getDataCallCount++;
    if (getDataError != null) throw getDataError!;
    return getDataResult;
  }
}