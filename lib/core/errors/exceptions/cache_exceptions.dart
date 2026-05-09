// core/errors/exceptions/cache_exceptions.dart
import 'base/app_exception.dart';

/// ==================== الاستثناء الأساسي لجميع أخطاء التخزين المؤقت ====================
abstract class CacheException extends AppException {
  final String? operation;
  final StackTrace? stackTrace;

  const CacheException({
    super.code,
    this.operation,
    this.stackTrace,
    super.statusCode,
    required super.message,
  });
}

/// ==================== أخطاء SharedPreferences ====================

/// خطأ في تهيئة SharedPreferences
class SharedPrefsInitException extends CacheException {
  final String? platformCode;

  const SharedPrefsInitException({
    required super.message,
    this.platformCode,
    super.code = 'SHARED_PREFS_INIT_ERROR',
    super.stackTrace,
  });
}

/// خطأ ناتج عن PlatformException (مشاكل في المنصة)
class SharedPrefsPlatformException extends CacheException {
  final String? platformCode;

  const SharedPrefsPlatformException({
    required super.message,
    this.platformCode,
    super.code = 'SHARED_PREFS_PLATFORM_ERROR',
    super.stackTrace,
  });
}

/// خطأ في عمليات SharedPreferences (get/set/remove)
class SharedPrefsOperationException extends CacheException {
  final String? key;

  const SharedPrefsOperationException({
    required super.message,
    this.key,
    super.operation,
    super.code = 'SHARED_PREFS_OPERATION_ERROR',
    super.stackTrace,
  });
}

/// خطأ في قراءة البيانات من SharedPreferences
class SharedPrefsReadException extends SharedPrefsOperationException {
  const SharedPrefsReadException({
    required super.message,
    super.key,
    super.operation = 'read',
    super.code = 'SHARED_PREFS_READ_ERROR',
  });
}

/// خطأ في كتابة البيانات إلى SharedPreferences
class SharedPrefsWriteException extends SharedPrefsOperationException {
  const SharedPrefsWriteException({
    required super.message,
    super.key,
    super.operation = 'write',
    super.code = 'SHARED_PREFS_WRITE_ERROR',
  });
}

/// خطأ _CastError أثناء تحويل البيانات
class SharedPrefsCastException extends CacheException {
  final String? key;
  final String? expectedType;

  const SharedPrefsCastException({
    required super.message,
    this.key,
    this.expectedType,
    super.code = 'SHARED_PREFS_CAST_ERROR',
    super.stackTrace,
  });
}

/// خطأ MissingPluginException
class SharedPrefsPluginException extends CacheException {
  const SharedPrefsPluginException({
    required super.message,
    super.code = 'SHARED_PREFS_PLUGIN_ERROR',
    super.stackTrace,
  });
}

/// ==================== أخطاء Hive ====================

/// خطأ عام في Hive
class HiveCacheException extends CacheException {
  const HiveCacheException({
    required super.message,
    super.code = 'HIVE_ERROR',
    super.stackTrace,
    super.operation,
  });
}

/// خطأ في Box (مغلق، غير موجود، null)
class HiveBoxException extends HiveCacheException {
  final String? boxName;

  const HiveBoxException({
    required super.message,
    this.boxName,
    super.code = 'HIVE_BOX_ERROR',
    super.stackTrace,
  });
}

/// خطأ في فتح Hive Box
class HiveOpenBoxException extends HiveBoxException {
  final String boxName;
  final String? path;

  const HiveOpenBoxException({
    required this.boxName,
    required super.message,
    this.path,
    super.code = 'HIVE_OPEN_BOX_ERROR',
    super.stackTrace,
  });
}

/// خطأ في إغلاق Hive Box
class HiveCloseBoxException extends HiveBoxException {
  const HiveCloseBoxException({
    required super.message,
    super.boxName,
    super.code = 'HIVE_CLOSE_BOX_ERROR',
    super.stackTrace,
  });
}

/// خطأ في عمليات CRUD على Hive
class HiveOperationException extends HiveCacheException {
  final String? boxName;
  final dynamic key;

  const HiveOperationException({
    required super.message,
    this.boxName,
    this.key,
    super.operation,
    super.code = 'HIVE_OPERATION_ERROR',
    super.stackTrace,
  });
}

/// خطأ في حفظ البيانات إلى Hive
class HiveSaveException extends HiveOperationException {
  const HiveSaveException({
    required super.message,
    super.boxName,
    super.key,
    super.operation = 'save',
    super.code = 'HIVE_SAVE_ERROR',
  });
}

/// خطأ في قراءة البيانات من Hive
class HiveReadException extends HiveOperationException {
  const HiveReadException({
    required super.message,
    super.boxName,
    super.key,
    super.operation = 'read',
    super.code = 'HIVE_READ_ERROR',
  });
}

/// خطأ في حذف البيانات من Hive
class HiveDeleteException extends HiveOperationException {
  const HiveDeleteException({
    required super.message,
    super.boxName,
    super.key,
    super.operation = 'delete',
    super.code = 'HIVE_DELETE_ERROR',
  });
}

/// خطأ في مسح كامل Box
class HiveClearException extends HiveOperationException {
  const HiveClearException({
    required super.message,
    super.boxName,
    super.operation = 'clear',
    super.code = 'HIVE_CLEAR_ERROR',
  });
}

/// ==================== أخطاء مسار التخزين ====================

/// خطأ في مسار التخزين (مهم لمنصات مثل OpenHarmony)
class StoragePathException extends CacheException {
  final String? attemptedPath;

  const StoragePathException({
    required super.message,
    this.attemptedPath,
    super.code = 'STORAGE_PATH_ERROR',
    super.stackTrace,
  });
}

/// ==================== أخطاء التشفير ====================

/// خطأ في تشفير/فك تشفير البيانات المخزنة
class CacheEncryptionException extends CacheException {
  const CacheEncryptionException({
    required super.message,
    super.code = 'CACHE_ENCRYPTION_ERROR',
    super.stackTrace,
  });
}

/// ==================== أخطاء أخرى ====================

/// خطأ في تهيئة نظام التخزين المؤقت
class CacheInitException extends CacheException {
  const CacheInitException({
    required super.message,
    super.code = 'CACHE_INIT_ERROR',
    super.stackTrace,
  });
}

/// خطأ في مساحة التخزين (امتلأت الذاكرة)
class CacheFullException extends CacheException {
  final int? requiredSpace;
  final int? availableSpace;

  const CacheFullException({
    required super.message,
    this.requiredSpace,
    this.availableSpace,
    super.code = 'CACHE_FULL_ERROR',
    super.stackTrace,
  });
}