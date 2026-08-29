import 'package:shared_preferences/shared_preferences.dart';
import '../../../errors/exceptions/cache_exceptions/shared_prefs_app_exceptions.dart';


class CacheHelper {

  static late SharedPreferences sharedPreferences;

  static final CacheHelper _instance = CacheHelper._internal();

  factory CacheHelper() => _instance;

  CacheHelper._internal();

  Future<void> init() async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
    }
    catch (e) {
      throw SharedPrefsInitializeException(error: e);
    }
  }

  Future<bool> setStringValue({
    required String key,
    required String value
  }) async {
    try {
      return await sharedPreferences.setString(key, value);
    }
    catch (e) {
      throw SharedPrefsSaveException(error: e);
    }
  }

  Future<String?> getStringValue({
    required String key
  }) async {
    try {
      return await sharedPreferences.getString(key);
    }
    catch (e) {
      throw SharedPrefsReadException(error: e);
    }
  }

  Future<bool> setIntValue({
    required String key,
    required int value
  }) async {
    try {
      return await sharedPreferences.setInt(key, value);
    }
    catch (e) {
      throw SharedPrefsSaveException(error: e);
    }
  }

  Future<int?> getIntValue({
    required String key
  }) async {
    try {
      return await sharedPreferences.getInt(key);
    }
    catch (e) {
      throw SharedPrefsReadException(error: e);
    }
  }

  Future<bool> removeValue({required String key}) async {
    try {
      return await sharedPreferences.remove(key);
    }
    catch (e) {
      throw SharedPrefsRemoveException(error: e);
    }
  }
}