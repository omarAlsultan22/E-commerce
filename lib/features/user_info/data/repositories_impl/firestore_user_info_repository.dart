import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/data/models/user_model.dart';
import '../../domain/repositories/user_info_repository.dart';
import '../../../../core/data/data_sources/remote/firestore.dart';
import 'package:international_cuisine/core/constants/app_keys.dart';
import '../../../../core/data/data_sources/local/shared_preferences.dart';


class FirestoreUserInfoRepository implements UserInfoRepository {
  final CacheHelper _cacheHelper;
  final FirestoreService _repository;

  FirestoreUserInfoRepository({
    required CacheHelper cacheHelper,
    required FirestoreService repository
  })
      : _repository = repository,
        _cacheHelper = cacheHelper;

  @override
  Future<void> createUserInfo({
    required UserModel userModel,
    required UserCredential userCredential
  }) async {
    try {
      final uId = userCredential.user!.uid;
      await _repository.setData(
          collectionPath: AppKeys.userInfo,
          docId: uId,
          data: userModel.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> getInfo() async {
    try {
      final userId = await _cacheHelper.getStringValue(key: AppKeys.uId);
      final jsonData = await _repository.getDocument(
          collectionPath: AppKeys.userInfo, docId: userId!);
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
      final userId = await _cacheHelper.getStringValue(key: AppKeys.uId);

      final userModel = UserModel(
        firstName: firstName,
        lastName: lastName,
        userPhone: userPhone,
        userLocation: userLocation,
      );
      await _repository.updateDocument(
          collectionPath: AppKeys.userInfo, docId: userId!, data: userModel.toJson());
    }
    catch (e) {
      rethrow;
    }
  }
}