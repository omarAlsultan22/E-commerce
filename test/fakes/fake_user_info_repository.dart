import 'package:international_cuisine/core/data/models/user_model.dart';
import 'package:international_cuisine/features/user_info/domain/repositories/user_info_repository.dart';


class FakeUserInfoRepository implements UserInfoRepository {
  // ===== getInfo =====
  UserModel getInfoResult = UserModel(
    firstName: 'Ali',
    lastName: 'Ahmed',
    userPhone: '0123',
    userLocation: 'Cairo',
  );
  Object? getInfoError;
  int getInfoCallCount = 0;

  @override
  Future<UserModel> getInfo() async {
    getInfoCallCount++;
    if (getInfoError != null) throw getInfoError!;
    return getInfoResult;
  }

  // ===== updateInfo =====
  int updateInfoCallCount = 0;
  String? lastFirstName;
  String? lastLastName;
  String? lastUserPhone;
  String? lastUserLocation;
  Object? updateInfoError;

  @override
  Future<void> updateInfo({
    required String firstName,
    required String lastName,
    required String userPhone,
    required String userLocation,
  }) async {
    updateInfoCallCount++;
    lastFirstName = firstName;
    lastLastName = lastName;
    lastUserPhone = userPhone;
    lastUserLocation = userLocation;
    if (updateInfoError != null) throw updateInfoError!;
  }
}