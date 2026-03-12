import 'package:international_cuisine/core/data/models/user_info_model.dart';


abstract class BaseUserInfoRepository {
  Future<UserInfoModel> getInfo();
}