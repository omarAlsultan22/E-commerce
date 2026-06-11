import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants/app_keys.dart';
import '../../../../core/data/models/user_model.dart';
import '../../domain/repositories/sign_up_repository.dart';
import '../../../../core/data/data_sources/remote/firestore.dart';


class FirebaseSignUpRepository implements SignUpRepository {
  final FirestoreService _repository;

  FirebaseSignUpRepository({
    required FirestoreService repository
  }) : _repository = repository;

  @override
  Future<void> createUserInfo({
    required UserModel userModel,
    required UserCredential userCredential
  }) async {
    try {
      await _repository.setData(
          collectionPath: AppKeys.userInfo,
          docId: userCredential.user!.uid,
          data: userModel.toJson());
    } catch (e) {
      rethrow;
    }
  }
}