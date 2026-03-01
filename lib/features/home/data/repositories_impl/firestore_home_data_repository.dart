import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/home_data_repository.dart';
import 'package:international_cuisine/features/home/data/models/home_model.dart';
import 'package:international_cuisine/features/home/utils/helpers/home_data_converter.dart';


class FirestoreHomeDataRepository implements HomeDataRepository {
  final FirebaseFirestore _repository;

  FirestoreHomeDataRepository({required FirebaseFirestore repository})
      : _repository = repository;

  static const homeData = 'homeData';

  @override
  Future<List<HomeDataModel>> getData() async {
    try {
      final jsonData = await _repository.collection(homeData).get();
      return HomeModelConverter
          .fromQuerySnapshot(jsonData)
          .data;
    }
    catch (e) {
      rethrow;
    }
  }
}