import '../../domain/repositories/home_data_repository.dart';
import '../../../../core/domain/data_sources/remote/firestore_service.dart';
import 'package:international_cuisine/features/home/data/models/home_model.dart';
import 'package:international_cuisine/features/home/utils/helpers/home_data_converter.dart';


class HomeDataRepositoryImpl implements HomeDataRepository {
  final FirestoreService _dataSource;

  HomeDataRepositoryImpl({required FirestoreService dataSource})
      : _dataSource = dataSource;

  static const homeData = 'homeData';

  @override
  Future<List<HomeDataModel>> getData() async {
      final jsonData = await _dataSource.getSupCollection(
          collectionPath: homeData);
      return HomeModelConverter
          .fromQuerySnapshot(jsonData)
          .data;
  }
}