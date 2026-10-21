import 'package:international_cuisine/core/domain/repositories/base_user_repository.dart';


abstract class UserInfoRepository implements BaseUserInfoRepository {
  Future<void> updateInfo({
    required String firstName,
    required String lastName,
    required String userPhone,
    required String userLocation
  });
}