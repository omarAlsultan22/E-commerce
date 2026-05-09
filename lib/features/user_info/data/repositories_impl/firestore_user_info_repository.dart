import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/data/models/user_model.dart';
import '../../domain/repositories/user_info_repository.dart';
import 'package:international_cuisine/core/constants/app_keys.dart';
import '../../../../core/data/data_sources/local/shared_preferences.dart';
import '../../../../core/data/data_sources/remote/firestore.dart';


class FirestoreUserInfoRepository implements UserInfoRepository {
  final CacheHelper _cacheHelper;
  final FirestoreService _repository;

  FirestoreUserInfoRepository({
    required CacheHelper cacheHelper,
    required FirestoreService repository
  })
      : _repository = repository,
        _cacheHelper = cacheHelper;

  static const _uId = AppKeys.uId;
  static const _userInfo = AppKeys.userInfo;

  @override
  Future<void> createUserInfo({
    required UserModel userModel,
    required UserCredential userCredential
  }) async {
    try {
      final uId = userCredential.user!.uid;
      await _repository.setData(
          collectionPath: _userInfo,
          docId: uId,
          data: userModel.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> getInfo() async {
    try {
      final userId = await _cacheHelper.getStringValue(key: _uId);
      final jsonData = await _repository.getDocument(
          collectionPath: _userInfo, docId: userId!);
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
      final userId = await _cacheHelper.getStringValue(key: _uId);

      final userModel = UserModel(
        firstName: firstName,
        lastName: lastName,
        userPhone: userPhone,
        userLocation: userLocation,
      );
      await _repository.updateDocument(
          collectionPath: _userInfo, docId: userId!, data: userModel.toJson());
    }
    catch (e) {
      rethrow;
    }
  }
}