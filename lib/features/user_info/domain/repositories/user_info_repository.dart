import 'package:international_cuisine/core/data/repositories_impl/base_user_repository.dart';


abstract class UserInfoRepository implements BaseUserInfoRepository {
  Future<void> updateInfo({
    required String firstName,
    required String lastName,
    required String userPhone,
    required String userLocation
  });
}