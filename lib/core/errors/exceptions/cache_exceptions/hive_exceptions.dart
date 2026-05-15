import '../base/app_exception.dart';
import 'base/cache_exceptions.dart';


class HiveException extends CacheException {
  HiveException({
    super.code,
    super.error,
    super.message,
    super.operation
  });

  static String? extractBoxName(String errorString) {
    // Create the Regex separately and safely
    const pattern = r'box\s+["'']?(\w+)["'']?';
    final regex = RegExp(pattern);
    final match = regex.firstMatch(errorString);
    return match?.group(1);
  }

  static final Map<String,
      AppException Function(String errorMsg)> _errorFactories = {
    'box has already been closed': (msg) =>
        HiveBoxException(
          message: 'محاولة الوصول إلى قاعدة بيانات مغلقة',
          code: 'HIVE_BOX_CLOSED',
        ),
    'box not found': (msg) =>
        HiveBoxException(
          message: 'قاعدة البيانات غير موجودة',
          code: 'HIVE_BOX_NOT_FOUND',
        ),
    'box doesn\'t exist': (msg) =>
        HiveBoxException(
          message: 'قاعدة البيانات غير موجودة',
          code: 'HIVE_BOX_NOT_FOUND',
        ),
    'null': (msg) =>
        HiveBoxException(
          message: 'لم تتم تهيئة قاعدة البيانات بشكل صحيح',
          code: 'HIVE_BOX_NULL',
        ),
    'box': (msg) =>
        HiveBoxException(
          message: 'لم تتم تهيئة قاعدة البيانات بشكل صحيح',
          code: 'HIVE_BOX_NULL',
        ),
    'openbox': (msg) =>
        HiveOpenBoxException(
          boxName: extractBoxName(msg) ?? 'unknown',
          message: 'فشل في فتح قاعدة البيانات: $msg',
        ),
    'failed to open': (msg) =>
        HiveOpenBoxException(
          boxName: extractBoxName(msg) ?? 'unknown',
          message: 'فشل في فتح قاعدة البيانات: $msg',
        ),
    'filesystemexception': (msg) =>
        HiveOperationException(
          message: 'حدث خطأ في ملف قاعدة البيانات',
          operation: 'file_system',
        ),
    'file closed': (msg) =>
        HiveOperationException(
          message: 'حدث خطأ في ملف قاعدة البيانات',
          operation: 'file_system',
        ),
    'compaction': (msg) =>
        HiveOperationException(
          message: 'حدث خطأ أثناء ضغط قاعدة البيانات',
          operation: 'compaction',
        ),
    'encryption': (msg) =>
        HiveOperationException(
          message: 'خطأ في تشفير/فك تشفير قاعدة البيانات',
          operation: 'encryption',
        ),
    'decryption': (msg) =>
        HiveOperationException(
          message: 'خطأ في تشفير/فك تشفير قاعدة البيانات',
          operation: 'encryption',
        ),
    'put': (msg) =>
        HiveOperationException(
          message: 'فشل في حفظ البيانات إلى قاعدة البيانات',
          operation: 'put',
        ),
    'get': (msg) =>
        HiveOperationException(
          message: 'فشل في قراءة البيانات من قاعدة البيانات',
          operation: 'get',
        ),
    'delete': (msg) =>
        HiveOperationException(
          message: 'فشل في حذف البيانات من قاعدة البيانات',
          operation: 'delete',
        ),
  };

  @override
  AppException getException() {
    final errorStr = error.toString().toLowerCase();

    final isKeyFound = _errorFactories.containsKey(error);
    if (isKeyFound) {
      return _errorFactories[errorStr]!(errorStr);
    }
    return HiveOperationException(
      message: error.message ?? 'خطأ في التخزين المحلي: ${error.toString()}',
    );
  }
}


class HiveCacheException extends HiveException {
  HiveCacheException({
    super.code = 'HIVE_ERROR',
    super.operation,
    super.message,
  });
}

/// خطأ في Box (مغلق، غير موجود، null)
class HiveBoxException extends HiveException {
  final String? boxName;

  HiveBoxException({
    super.message,
    this.boxName,
    super.code = 'HIVE_BOX_ERROR',
  });
}

/// خطأ في فتح Hive Box
class HiveOpenBoxException extends HiveException {
  final String boxName;
  final String? path;

  HiveOpenBoxException({
    required this.boxName,
    super.message,
    this.path,
    super.code = 'HIVE_OPEN_BOX_ERROR',
  });
}

/// خطأ في إغلاق Hive Box
class HiveCloseBoxException extends HiveException {
  HiveCloseBoxException({
    super.message,
    super.code = 'HIVE_CLOSE_BOX_ERROR',
  });
}

/// خطأ في عمليات CRUD على Hive
class HiveOperationException extends HiveException {
  final String? boxName;
  final dynamic key;

  HiveOperationException({
    super.message,
    this.boxName,
    this.key,
    super.operation,
    super.code = 'HIVE_OPERATION_ERROR',
  });
}

/// خطأ في حفظ البيانات إلى Hive
class HiveSaveException extends HiveException {
  HiveSaveException({
    super.message,
    super.operation = 'save',
    super.code = 'HIVE_SAVE_ERROR',
  });
}

/// خطأ في قراءة البيانات من Hive
class HiveReadException extends HiveException {
  HiveReadException({
    super.message,
    super.operation = 'read',
    super.code = 'HIVE_READ_ERROR',
  });
}

/// خطأ في حذف البيانات من Hive
class HiveDeleteException extends HiveException {
  HiveDeleteException({
    super.message,
    super.operation = 'delete',
    super.code = 'HIVE_DELETE_ERROR',
  });
}

/// خطأ في مسح كامل Box
class HiveClearException extends HiveException {
  HiveClearException({
    super.message,
    super.operation = 'clear',
    super.code = 'HIVE_CLEAR_ERROR',
  });
}