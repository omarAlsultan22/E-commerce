import '../../../../core/data/models/user_model.dart';
import '../../domain/repositories/user_info_repository.dart';
import 'package:international_cuisine/core/constants/app_keys.dart';
import 'package:international_cuisine/core/services/session_service.dart';
import '../../../../core/domain/data_sources/remote/firestore_service.dart';


class UserInfoRepositoryImpl implements UserInfoRepository {
  final FirestoreService _dataSource;
  final SessionService _sessionService;

  UserInfoRepositoryImpl({
    required FirestoreService dataSource,
    required SessionService sessionService,
  })
      : _dataSource = dataSource,
        _sessionService = sessionService;

  @override
  Future<UserModel> getInfo() async {
    final jsonData = await _dataSource.getDocument(
        collectionPath: AppKeys.userInfo, docId: _sessionService.currentUid);
    return UserModel.fromDocumentSnapshot(jsonData);
  }

  @override
  Future<void> updateInfo({
    required String firstName,
    required String lastName,
    required String userPhone,
    required String userLocation
  }) async {
    final userModel = UserModel(
      firstName: firstName,
      lastName: lastName,
      userPhone: userPhone,
      userLocation: userLocation,
    );
    await _dataSource.updateDocument(
        collectionPath: AppKeys.userInfo,
        docId: _sessionService.currentUid,
        data: userModel.toJson());
  }
}