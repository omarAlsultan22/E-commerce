import '../domain/data_sources/local/cache_helper.dart';


class SessionService {
  final CacheHelper _cacheHelper;

  SessionService({required CacheHelper cacheHelper})
      : _cacheHelper = cacheHelper;

  static const _uId = 'user_id';

  String _currentUid = '';

  String get currentUid => _currentUid;

  bool get isLoggedIn => _currentUid.isNotEmpty;

  Future<void> loadFromStorage() async {
    _currentUid = await _cacheHelper.getString(key: _uId);
  }

  Future<void> login(String uid) async {
    _currentUid = uid;

    await _cacheHelper.setString(key: _uId, value: uid);
  }

  Future<void> logout() async {
    _currentUid = '';

    await _cacheHelper.removeValue(key: _uId);
  }
}
