import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class LocalStorageService {
  final FlutterSecureStorage _storage;

  LocalStorageService(this._storage);

  Future<void> savePassword(String password) async {
    try {
      await _storage.write(key: 'user_password', value: password);
    } catch (e) {
      rethrow;
    }
  }
}