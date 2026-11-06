import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:international_cuisine/core/domain/data_sources/local/cache_helper.dart';
import 'package:international_cuisine/core/data/data_sources/local/cache_helper_impl.dart';


void main() {
  late CacheHelper cacheHelper;

  setUp(() async {
    // 1. تهيئة prefs وهمية فارغة قبل كل اختبار
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    cacheHelper = CacheHelperImpl(prefs: prefs);
  });

  group('CacheHelperImpl - String', () {
    test('setString saves and getString returns the same value', () async {
      final saved = await cacheHelper.setString(key: 'token', value: 'abc123');
      expect(saved, true);

      final result = await cacheHelper.getString(key: 'token');
      expect(result, 'abc123');
    });

    test('getString returns null when key does not exist', () async {
      final result = await cacheHelper.getString(key: 'missing');
      expect(result, isNull);
    });

    test('setString overwrites existing value', () async {
      await cacheHelper.setString(key: 'token', value: 'old');
      await cacheHelper.setString(key: 'token', value: 'new');

      expect(await cacheHelper.getString(key: 'token'), 'new');
    });
  });

  group('CacheHelperImpl - Int', () {
    test('setInt saves and getInt returns the same value', () async {
      final saved = await cacheHelper.setInt(key: 'age', value: 25);
      expect(saved, true);

      final result = await cacheHelper.getInt(key: 'age');
      expect(result, 25);
    });

    test('getInt returns null when key does not exist', () async {
      final result = await cacheHelper.getInt(key: 'missing');
      expect(result, isNull);
    });

    test('setInt overwrites existing value', () async {
      await cacheHelper.setInt(key: 'age', value: 20);
      await cacheHelper.setInt(key: 'age', value: 30);

      expect(await cacheHelper.getInt(key: 'age'), 30);
    });
  });

  group('CacheHelperImpl - independence', () {
    test('setting a string does not affect an int with the same key', () async {
      await cacheHelper.setString(key: 'k', value: 'text');
      await cacheHelper.setInt(key: 'k', value: 99);

      // shared_preferences يخزن كل نوع في مساحة منفصلة
      expect(await cacheHelper.getString(key: 'k'), 'text');
      expect(await cacheHelper.getInt(key: 'k'), 99);
    });

    test('different keys are independent', () async {
      await cacheHelper.setString(key: 'a', value: 'A');
      await cacheHelper.setString(key: 'b', value: 'B');

      expect(await cacheHelper.getString(key: 'a'), 'A');
      expect(await cacheHelper.getString(key: 'b'), 'B');
    });
  });
}