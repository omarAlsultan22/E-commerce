import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/data/models/user_info_model.dart';
import '../../domain/repositories/user_info_repository.dart';
import 'package:international_cuisine/core/constants/app_keys.dart';
import '../../../../core/data/data_sources/local/shared_preferences.dart';


class FirestoreUserInfoRepository implements UserInfoRepository {
  final FirebaseFirestore _repository;

  FirestoreUserInfoRepository({required FirebaseFirestore repository})
      : _repository = repository;

  static const  _uId = AppKeys.uId;
  static const _userInfo = AppKeys.userInfo;

  @override
  Future<void> setInfo({
    required UserInfoModel userModel,
    required UserCredential userCredential
  }) async {
    try {
      final uId = userCredential.user!.uid;
      await _repository.collection(_userInfo).doc(uId).set(
          userModel.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserInfoModel> getInfo() async {
    try {
      final userId = await CacheHelper.getStringValue(key: _uId);
      final jsonData = await _repository.collection(_userInfo)
          .doc(userId).get();
      return UserInfoModel.fromDocumentSnapshot(jsonData);
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
      final userId = await CacheHelper.getStringValue(key: _uId);

      final userModel = UserInfoModel(
        firstName: firstName,
        lastName: lastName,
        userPhone: userPhone,
        userLocation: userLocation,
      );
      await _repository.collection(_userInfo).doc(userId)
          .update(userModel.toJson());
    }
    catch (e) {
      rethrow;
    }
  }
}