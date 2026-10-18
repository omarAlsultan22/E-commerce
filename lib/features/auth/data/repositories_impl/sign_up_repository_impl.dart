import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants/app_keys.dart';
import '../../../../core/data/models/user_model.dart';
import '../../domain/repositories/sign_up_repository.dart';
import '../../../../core/domain/data_sources/remote/firestore_service.dart';


class SignUpRepositoryImpl implements SignUpRepository {
  final FirestoreService _service;

  SignUpRepositoryImpl({
    required FirestoreService service
  }) : _service = service;

  @override
  Future<void> createUserInfo({
    required UserModel userModel,
    required UserCredential userCredential
  }) async {
    await _service.setData(
        collectionPath: AppKeys.userInfo,
        docId: userCredential.user!.uid,
        data: userModel.toJson());
  }
}