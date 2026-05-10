import 'dart:io';
import 'dart:async';
import 'package:hive/hive.dart';
import 'package:flutter/services.dart';
import 'exceptions/cache_exceptions.dart';
import 'exceptions/unknown_exception.dart';
import 'exceptions/network_exception.dart';
import 'exceptions/base/app_exception.dart';
import 'exceptions/firebase_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:international_cuisine/core/domain/services/connectivity_service/connectivity_service.dart';


class ErrorHandler {

  // ==================== الدالة الرئيسية ====================

  static AppException handleException(dynamic error, {StackTrace? stackTrace}) {
    _logError(error, stackTrace);
    final _connectivityService = ConnectivityService();
    if (error is FirebaseException) {
      switch (error.code) {
        case 'unavailable':
        case 'network-error':
        case 'network-request-failed':
          return NetworkException(connectivityService: _connectivityService);
        case 'permission-denied':
          return FirebaseAppException(message: 'ليس لديك صلاحية للوصول');
        case 'not-found':
          return FirebaseAppException(message: 'البيانات غير موجودة');
        case 'already-exists':
          return FirebaseAppException(message: 'البيانات موجودة مسبقاً');
        case 'user-not-found':
          return FirebaseAppException(
              message: 'لم يتم تسجيل أي مستخدم بهذا البريد الإلكتروني');
        case 'invalid-email':
          return FirebaseAppException(message: 'عنوان البريد الإلكتروني غير صالح');
        default:
          return FirebaseAppException(message: 'خطأ في Firebase');
      }
    }

    if (_isSharedPrefsError(error)) {
      return _handleSharedPrefsError(error, stackTrace);
    }

    if (error is HiveError) {
      return _handleHiveError(error, stackTrace);
    }

    if (error is SocketException) {
      return NetworkException(connectivityService: _connectivityService);
    }

    if (error is TimeoutException) {
      return NetworkException(connectivityService: _connectivityService);
    }

    return UnknownException(message: error.toString());
  }

  // ==================== دالة المساعدة للتحقق ====================

  static bool _isSharedPrefsError(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    return error is PlatformException &&
        (errorStr.contains('shared_preferences') ||
            errorStr.contains('sharedpreferences')) ||
        error is MissingPluginException &&
            errorStr.contains('shared_preferences') ||
        errorStr.contains('sharedpreferences') ||
        errorStr.contains('preferences') && errorStr.contains('instance');
  }

  // ==================== SharedPreferences Error Handler ====================

  static AppException _handleSharedPrefsError(dynamic error,
      StackTrace? stackTrace) {
    final errorStr = error.toString().toLowerCase();

    // PlatformException (الأكثر شيوعاً)
    if (error is PlatformException) {
      final message = error.message?.toLowerCase() ?? '';

      if (message.contains('streamcorrupted') ||
          message.contains('invalid stream header')) {
        return SharedPrefsInitException(
          message: 'ملف التخزين المحلي تالف، سيتم إعادة تهيئته',
          platformCode: error.code,
          stackTrace: stackTrace,
        );
      }

      if (message.contains('channel-error') ||
          message.contains('unable to establish connection')) {
        return SharedPrefsPlatformException(
          message: 'مشكلة في الاتصال مع نظام التخزين',
          platformCode: error.code,
          stackTrace: stackTrace,
        );
      }

      return SharedPrefsPlatformException(
        message: error.message ?? 'خطأ في منصة التخزين المحلي',
        platformCode: error.code,
        stackTrace: stackTrace,
      );
    }

    // MissingPluginException
    if (error is MissingPluginException) {
      return SharedPrefsPluginException(
        message: 'مشكلة في تهيئة التخزين المحلي، يرجى إعادة تشغيل التطبيق',
        stackTrace: stackTrace,
      );
    }

    // _CastError (خطأ في تحويل النوع)
    if (errorStr.contains('_casterror') ||
        errorStr.contains('null check operator')) {
      return SharedPrefsCastException(
        message: 'خطأ في نوع البيانات المخزنة',
        stackTrace: stackTrace,
      );
    }

    // أخطاء التهيئة العامة
    if (errorStr.contains('getinstance') ||
        errorStr.contains('not initialized') ||
        errorStr.contains('binding has not been initialized')) {
      return SharedPrefsInitException(
        message: 'لم يتم تهيئة التخزين المحلي بشكل صحيح',
        stackTrace: stackTrace,
      );
    }

    // أخطاء القراءة/الكتابة
    if (errorStr.contains('read') || errorStr.contains('get')) {
      return SharedPrefsOperationException(
        message: 'فشل قراءة البيانات من التخزين المحلي',
        operation: 'read',
        stackTrace: stackTrace,
      );
    }

    if (errorStr.contains('write') || errorStr.contains('set') ||
        errorStr.contains('save')) {
      return SharedPrefsOperationException(
        message: 'فشل حفظ البيانات في التخزين المحلي',
        operation: 'write',
        stackTrace: stackTrace,
      );
    }

    // أي خطأ آخر
    return SharedPrefsOperationException(
      message: 'خطأ في التخزين المحلي: ${error.toString()}',
      stackTrace: stackTrace,
    );
  }

  // ==================== Hive Error Handler ====================

  static AppException _handleHiveError(dynamic error, StackTrace? stackTrace) {
    final errorString = error.toString().toLowerCase();

    // أخطاء الـ Box
    if (errorString.contains('box has already been closed')) {
      return HiveBoxException(
        message: 'محاولة الوصول إلى قاعدة بيانات مغلقة',
        code: 'HIVE_BOX_CLOSED',
        stackTrace: stackTrace,
      );
    }

    if (errorString.contains('box not found') ||
        errorString.contains('box doesn\'t exist')) {
      return HiveBoxException(
        message: 'قاعدة البيانات غير موجودة',
        code: 'HIVE_BOX_NOT_FOUND',
        stackTrace: stackTrace,
      );
    }

    if (errorString.contains('null') && errorString.contains('box')) {
      return HiveBoxException(
        message: 'لم يتم تهيئة قاعدة البيانات بشكل صحيح',
        code: 'HIVE_BOX_NULL',
        stackTrace: stackTrace,
      );
    }

    // أخطاء فتح الـ Box
    if (errorString.contains('openbox') ||
        errorString.contains('failed to open')) {
      final boxName = _extractBoxName(errorString);
      return HiveOpenBoxException(
        boxName: boxName ?? 'unknown',
        message: 'فشل فتح قاعدة البيانات: ${error.toString()}',
        stackTrace: stackTrace,
      );
    }

    // أخطاء ملفات Hive
    if (errorString.contains('filesystemexception') ||
        errorString.contains('file closed')) {
      return HiveOperationException(
        message: 'حدث خطأ في ملف قاعدة البيانات',
        operation: 'file_system',
        stackTrace: stackTrace,
      );
    }

    if (errorString.contains('compaction')) {
      return HiveOperationException(
        message: 'حدث خطأ أثناء ضغط قاعدة البيانات',
        operation: 'compaction',
        stackTrace: stackTrace,
      );
    }

    // أخطاء التشفير
    if (errorString.contains('encryption') ||
        errorString.contains('decryption')) {
      return HiveOperationException(
        message: 'خطأ في تشفير/فك تشفير قاعدة البيانات',
        operation: 'encryption',
        stackTrace: stackTrace,
      );
    }

    // أخطاء عمليات CRUD
    if (errorString.contains('put')) {
      return HiveOperationException(
        message: 'فشل حفظ البيانات في قاعدة البيانات',
        operation: 'put',
        stackTrace: stackTrace,
      );
    }

    if (errorString.contains('get')) {
      return HiveOperationException(
        message: 'فشل قراءة البيانات من قاعدة البيانات',
        operation: 'get',
        stackTrace: stackTrace,
      );
    }

    if (errorString.contains('delete')) {
      return HiveOperationException(
        message: 'فشل حذف البيانات من قاعدة البيانات',
        operation: 'delete',
        stackTrace: stackTrace,
      );
    }

    // أي خطأ آخر في Hive
    if (error is HiveError) {
      return HiveOperationException(
        message: error.message,
        stackTrace: stackTrace,
      );
    }

    return HiveCacheException(
      message: 'خطأ في التخزين المحلي: ${error.toString()}',
      stackTrace: stackTrace,
    );
  }

  // ==================== دوال مساعدة ====================

  static String? _extractBoxName(String errorString) {
    // إنشاء الـ Regex بشكل منفصل وآمن
    const pattern = r'box\s+["'']?(\w+)["'']?';
    final regex = RegExp(pattern);
    final match = regex.firstMatch(errorString);
    return match?.group(1);
  }

  static void _logError(dynamic error, StackTrace? stackTrace) {
    // للتتبع والتحليلات
    print('════════════════════════════════════════');
    print('❌ Error caught: ${error.runtimeType}');
    print('Message: $error');
    if (stackTrace != null) {
      print('StackTrace: $stackTrace');
    }
    print('════════════════════════════════════════');
  }
}