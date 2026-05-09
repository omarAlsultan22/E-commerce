import 'package:shared_preferences/shared_preferences.dart';


class CacheHelper {

  static late SharedPreferences sharedPreferences;

  init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<bool> setStringValue({
    required String key,
    required String value
  }) async {
    return await sharedPreferences.setString(key, value);
  }

  Future<String?> getStringValue({
    required String key
  }) async {
    return await sharedPreferences.getString(key);
  }

  Future<bool> setIntValue({
    required String key,
    required int value
  }) async {
    return await sharedPreferences.setInt(key, value);
  }

  Future<int?> getIntValue({
    required String key
  }) async {
    return await sharedPreferences.getInt(key);
  }

  Future<bool> removeValue({required String key}) async {
    return await sharedPreferences.remove(key);
  }
}