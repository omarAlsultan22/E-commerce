import 'package:international_cuisine/core/data/models/user_model.dart';


abstract class BaseUserInfoRepository {
  Future<UserModel> getInfo();
}