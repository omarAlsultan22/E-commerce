import '../repositories/user_info_repository.dart';
import '../../../../core/data/models/user_model.dart';


class UserInfoUseCase {
  final UserInfoRepository _repository;

  UserInfoUseCase({
    required UserInfoRepository userInfoRepository,
  })
      :_repository = userInfoRepository;

  Future<UserModel?> getInfoExecute() async {
    return await _repository.getInfo();
  }

  Future<void> updateInfoExecute({
    required String firstName,
    required String lastName,
    required String userPhone,
    required String userLocation
  }) async {
    return await _repository.updateInfo(
        firstName: firstName,
        lastName: lastName,
        userPhone: userPhone,
        userLocation: userLocation

    );
  }
}

