import '../base/app_exception.dart';
import 'base/cache_app_exceptions.dart';
import '../base/exception_handler.dart';


class HiveAppException extends CacheAppException implements ExceptionHandler {
  HiveAppException({
    super.code,
    super.error,
    super.message,
    super.operation
  });

  static const String _msgDatabaseNotExist = 'قاعدة البيانات غير موجودة';
  static const String _msgFileSystemError = 'حدث خطأ في ملف قاعدة البيانات';
  static const String _msgNotInitialized = 'لم تتم تهيئة قاعدة البيانات بشكل صحيح';
  static const String _msgEncryptionError = 'خطأ في تشفير/فك تشفير قاعدة البيانات';

  static String? _extractBoxName(String errorString) {
    // Create the Regex separately and safely
    const pattern = r'box\s+["'']?(\w+)["'']?';
    final regex = RegExp(pattern);
    final match = regex.firstMatch(errorString);
    return match?.group(1);
  }

  static final Map<String,
      AppException Function(String)> _errorFactories = {
    'box has already been closed': (msg) =>
        HiveBoxException(
          message: 'محاولة الوصول إلى قاعدة بيانات مغلقة',
          code: 'HIVE_BOX_CLOSED',
        ),
    'box not found': (msg) =>
        HiveBoxException(
          message: _msgDatabaseNotExist,
          code: 'HIVE_BOX_NOT_FOUND',
        ),
    'box doesn\'t exist': (msg) =>
        HiveBoxException(
          message: _msgDatabaseNotExist,
          code: 'HIVE_BOX_NOT_FOUND',
        ),
    'null': (msg) =>
        HiveBoxException(
          message: _msgNotInitialized,
          code: 'HIVE_BOX_NULL',
        ),
    'box': (msg) =>
        HiveBoxException(
          message: _msgNotInitialized,
          code: 'HIVE_BOX_NULL',
        ),
    'openbox': (msg) =>
        HiveOpenBoxException(
          boxName: _extractBoxName(msg) ?? 'unknown',
          message: 'فشل في فتح قاعدة البيانات: $msg',
        ),
    'failed to open': (msg) =>
        HiveOpenBoxException(
          boxName: _extractBoxName(msg) ?? 'unknown',
          message: 'فشل في فتح قاعدة البيانات: $msg',
        ),
    'filesystemexception': (msg) =>
        HiveOperationException(
          message: _msgFileSystemError,
          operation: 'file_system',
        ),
    'file closed': (msg) =>
        HiveOperationException(
          message: _msgFileSystemError,
          operation: 'file_system',
        ),
    'compaction': (msg) =>
        HiveOperationException(
          message: 'حدث خطأ أثناء ضغط قاعدة البيانات',
          operation: 'compaction',
        ),
    'encryption': (msg) =>
        HiveOperationException(
          message: _msgEncryptionError,
          operation: 'encryption',
        ),
    'decryption': (msg) =>
        HiveOperationException(
          message: _msgEncryptionError,
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
  bool canHandle() {
    final errorStr = error.toString().toLowerCase();
    return _errorFactories.containsKey(errorStr);
  }

  @override
  AppException handle() {
    if (canHandle()) {
      final errorStr = error.toString().toLowerCase();
      return _errorFactories[errorStr]!(errorStr);
    }
    return HiveOperationException(
      message: error.message ?? 'خطأ في التخزين المحلي: ${error.toString()}',
    );
  }
}


class HiveCacheException extends HiveAppException {
  HiveCacheException({
    super.code = 'HIVE_ERROR',
    super.operation,
    super.message,
  });
}

/// خطأ في Box (مغلق، غير موجود، null)
class HiveBoxException extends HiveAppException {
  final String? boxName;

  HiveBoxException({
    super.message,
    this.boxName,
    super.code = 'HIVE_BOX_ERROR',
  });
}


class HiveOpenBoxException extends HiveAppException {
  final String boxName;
  final String? path;

  HiveOpenBoxException({
    required this.boxName,
    super.message,
    this.path,
    super.code = 'HIVE_OPEN_BOX_ERROR',
  });
}


class HiveCloseBoxException extends HiveAppException {
  HiveCloseBoxException({
    super.message,
    super.code = 'HIVE_CLOSE_BOX_ERROR',
  });
}


class HiveOperationException extends HiveAppException {
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


class HiveSaveException extends HiveAppException {
  HiveSaveException({
    super.message,
    super.operation = 'save',
    super.code = 'HIVE_SAVE_ERROR',
  });
}


class HiveReadException extends HiveAppException {
  HiveReadException({
    super.message,
    super.operation = 'read',
    super.code = 'HIVE_READ_ERROR',
  });
}


class HiveDeleteException extends HiveAppException {
  HiveDeleteException({
    super.message,
    super.operation = 'delete',
    super.code = 'HIVE_DELETE_ERROR',
  });
}


class HiveClearException extends HiveAppException {
  HiveClearException({
    super.message,
    super.operation = 'clear',
    super.code = 'HIVE_CLEAR_ERROR',
  });
}