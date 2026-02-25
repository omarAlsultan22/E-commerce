import 'package:international_cuisine/core/errors/exceptions/server_exception.dart';
import 'package:international_cuisine/features/home/data/models/home_model.dart';
import '../repositories/home_data_repository.dart';


class HomeDataUseCase {
  final HomeDataRepository _repository;

  HomeDataUseCase({
    required HomeDataRepository userInfoRepository,
  })
      :_repository = userInfoRepository;

  Future<List<HomeDataModel>> getDataExecute() async {
    try {
      final data = await _repository.getData();
      if (data.isEmpty) {
        throw ServerException(message: 'There is no data');
      }
      return data;
    }
    catch (e) {
      rethrow;
    }
  }
}

