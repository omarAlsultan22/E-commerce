import 'package:shared_preferences/shared_preferences.dart';


class CacheHelper {

  static late SharedPreferences sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> setStringValue({
    required String key,
    required String value
  }) async {
    return await sharedPreferences.setString(key, value);
  }

  static Future<String?> getStringValue({
    required String key
  }) async {
    return await sharedPreferences.getString(key);
  }

  static Future<bool> setIntValue({
    required String key,
    required int value
  }) async {
    return await sharedPreferences.setInt(key, value);
  }

  static Future<int?> getIntValue({
    required String key
  }) async {
    return await sharedPreferences.getInt(key);
  }

  static Future<bool> removeValue({required String key}) async {
    return await sharedPreferences.remove(key);
  }
}