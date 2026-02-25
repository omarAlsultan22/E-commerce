import 'package:international_cuisine/core/data/models/user_info_model.dart';


abstract class BaseUserRepository {
  Future<UserInfoModel> getInfo();
}