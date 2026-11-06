import 'package:international_cuisine/core/domain/data_sources/local/cache_helper.dart';


class FakeCacheHelper implements CacheHelper {
  final Map<String, dynamic> _storage = {};

  // للتحكم في الأخطاء
  Object? setStringError;
  Object? getStringError;
  Object? removeValueError;

  @override
  Future<bool> setString({required String key, required String value}) async {
    if (setStringError != null) throw setStringError!;
    _storage[key] = value;
    return true;
  }

  @override
  Future<String> getString({required String key}) async {
    if (getStringError != null) throw getStringError!;
    return _storage[key] as String? ?? '';
  }
  // أو إذا كان String?:
  // Future<String?> getString({required String key}) async => _storage[key] as String?;

  @override
  Future<bool> setInt({required String key, required int value}) async {
    _storage[key] = value;
    return true;
  }

  @override
  Future<int> getInt({required String key}) async {
    return _storage[key] as int? ?? 0;
  }

  @override
  Future<bool> removeValue({required String key}) async {
    if (removeValueError != null) throw removeValueError!;
    _storage.remove(key);
    return true;
  }
}