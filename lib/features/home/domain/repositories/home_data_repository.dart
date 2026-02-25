import 'package:international_cuisine/features/home/data/models/home_model.dart';


abstract class HomeDataRepository {
  Future<List<HomeDataModel>> getData();
}