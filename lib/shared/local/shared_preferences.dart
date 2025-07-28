import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {

  static late SharedPreferences sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool?> setString({
    required String key, required String value}) async {
    return await sharedPreferences.setString(key , value);
  }

  static Future<String?> getString({
    required String key}) async {
    return await sharedPreferences.getString(key);
  }

  static Future<bool?> setInt({
    required String key, required int value}) async {
    return await sharedPreferences.setInt(key , value);
  }

  static Future<int?> getInt({
    required String key}) async {
    return await sharedPreferences.getInt(key);
  }

  static Future<bool> remove({required String key}) async {
    return await sharedPreferences.remove(key);
    //or await sharedPreferences.remove(); => remove specific element
  }

}