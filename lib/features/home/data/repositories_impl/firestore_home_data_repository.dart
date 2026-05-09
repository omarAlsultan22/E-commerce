import '../../domain/repositories/home_data_repository.dart';
import '../../../../core/data/data_sources/remote/firestore.dart';
import 'package:international_cuisine/features/home/data/models/home_model.dart';
import 'package:international_cuisine/features/home/utils/helpers/home_data_converter.dart';


class FirestoreHomeDataRepository implements HomeDataRepository {
  final FirestoreService _repository;

  FirestoreHomeDataRepository({required FirestoreService repository})
      : _repository = repository;

  static const homeData = 'homeData';

  @override
  Future<List<HomeDataModel>> getData() async {
    try {
      final jsonData = await _repository.getSupCollection(
          collectionPath: homeData);
      return HomeModelConverter
          .fromQuerySnapshot(jsonData)
          .data;
    }
    catch (e) {
      rethrow;
    }
  }
}