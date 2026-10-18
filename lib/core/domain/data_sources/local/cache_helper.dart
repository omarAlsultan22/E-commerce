abstract class CacheHelper {
  Future<void> init();

  Future<bool> setString({
    required String key,
    required String value
  });

  Future<String> getString({
    required String key
  });

  Future<bool> setInt({
    required String key,
    required int value
  });

  Future<int?> getInt({
    required String key
  });

  Future<bool> removeValue({required String key});
}