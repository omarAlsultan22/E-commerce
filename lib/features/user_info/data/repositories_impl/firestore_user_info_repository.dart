import '../../../../core/data/models/user_model.dart';
import '../../domain/repositories/user_info_repository.dart';
import '../../../../core/data/data_sources/remote/firestore.dart';
import 'package:international_cuisine/core/constants/app_keys.dart';
import '../../../../core/data/data_sources/local/cache_helper.dart';
import 'package:international_cuisine/core/services/session_service.dart';


class FirestoreUserInfoRepository implements UserInfoRepository {
  final FirestoreService _repository;
  final SessionService _sessionService;

  FirestoreUserInfoRepository({
    required CacheHelper cacheHelper,
    required FirestoreService repository,
    required SessionService sessionService,
  })
      : _repository = repository,
        _sessionService = sessionService;

  @override
  Future<UserModel> getInfo() async {
    try {
      final jsonData = await _repository.getDocument(
          collectionPath: AppKeys.userInfo, docId: 'Lcjp7FoCPAo0U3yqqRmm');
      return UserModel.fromDocumentSnapshot(jsonData);
    }
    catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateInfo({
    required String firstName,
    required String lastName,
    required String userPhone,
    required String userLocation
  }) async {
    try {
      final userModel = UserModel(
        firstName: firstName,
        lastName: lastName,
        userPhone: userPhone,
        userLocation: userLocation,
      );
      await _repository.updateDocument(
          collectionPath: AppKeys.userInfo,
          docId: _sessionService.currentUid,
          data: userModel.toJson());
    }
    catch (e) {
      rethrow;
    }
  }
}