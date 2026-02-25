import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/data/models/user_info_model.dart';
import '../../domain/repositories/user_info_repository.dart';
import '../../../../core/data/data_sources/local/shared_preferences.dart';


class FirestoreInfoRepository implements UserInfoRepository{
  final FirebaseFirestore _repository;

  FirestoreInfoRepository({required FirebaseFirestore repository})
      : _repository = repository;


  @override
  Future<void> setInfo({
    required UserInfoModel userModel,
    required UserCredential userCredential
  }) async {
    try {
      final uId = userCredential.user!.uid;
      await _repository.collection('user').doc(uId)
          .collection('userModel')
          .doc(uId)
          .set(
          userModel.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserInfoModel> getInfo() async {
    try {
      final uId = await CacheHelper.getStringValue(key: 'uId');
      final jsonData = await _repository.collection('user')
          .doc(uId).collection('userModel').doc(uId)
          .get();
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
      final uId = await CacheHelper.getStringValue(key: 'uId');

      final userModel = UserInfoModel(
        firstName: firstName,
        lastName: lastName,
        userPhone: userPhone,
        userLocation: userLocation,
      );
      await _repository.collection('user').doc(uId)
          .collection('userModel')
          .doc(uId)
          .update(userModel.toJson());
    }
    catch (e) {
      rethrow;
    }
  }
}