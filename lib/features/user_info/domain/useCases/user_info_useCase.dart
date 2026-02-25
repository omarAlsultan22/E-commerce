import '../../../../core/data/models/user_info_model.dart';
import '../repositories/user_info_repository.dart';


class UserInfoUseCase {
  final UserInfoRepository _repository;

  UserInfoUseCase({
    required UserInfoRepository userInfoRepository,
  })
      :_repository = userInfoRepository;

  Future<UserInfoModel> getInfoExecute() async {
    try {
      return await _repository.getInfo();
    }
    catch(e){
      rethrow;
    }
  }

  Future<void> updateInfoExecute({
    required String firstName,
    required String lastName,
    required String userPhone,
    required String userLocation
  }) async {
    try {
      return await _repository.updateInfo(
          firstName: firstName,
          lastName: lastName,
          userPhone: userPhone,
          userLocation: userLocation

      );
    }
    catch (e) {
      rethrow;
    }
  }
}

