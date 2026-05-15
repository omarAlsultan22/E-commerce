import 'dart:io';
import 'dart:async';
import 'package:hive/hive.dart';
import 'package:flutter/services.dart';
import '../exceptions/network_exception.dart';
import '../exceptions/firebase_exception.dart';
import '../exceptions/base/app_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../exceptions/cache_exceptions/hive_exceptions.dart';
import '../exceptions/cache_exceptions/shared_prefs_exceptions.dart';
import '../../domain/services/connectivity_service/connectivity_service.dart';
import 'package:international_cuisine/core/errors/exceptions/client_exception.dart';


class ExceptionMapper {
  final dynamic error;

  ExceptionMapper({required this.error});

  static final connectivityService = ConnectivityService();
  static final Map<String, AppException> _stringPatterns = {
    '_casterror': SharedPrefsCastException(
      message: 'خطأ في نوع البيانات المخزنة',
    ),
    'null check operator': SharedPrefsCastException(
      message: 'خطأ في نوع البيانات المخزنة',
    ),
    'getinstance': SharedPrefsInitException(
      message: 'لم تتم تهيئة التخزين المحلي بشكل صحيح',
    ),
    'not initialized': SharedPrefsInitException(
      message: 'لم تتم تهيئة التخزين المحلي بشكل صحيح',
    ),
    'binding has not been initialized': SharedPrefsInitException(
      message: 'لم تتم تهيئة التخزين المحلي بشكل صحيح',
    ),
    'read': SharedPrefsOperationException(
      message: 'فشل في قراءة البيانات من التخزين المحلي',
      operation: 'read',
    ),
    'get': SharedPrefsOperationException(
      message: 'فشل في قراءة البيانات من التخزين المحلي',
      operation: 'read',
    ),
    'write': SharedPrefsOperationException(
      message: 'فشل في حفظ البيانات إلى التخزين المحلي',
      operation: 'write',
    ),
    'set': SharedPrefsOperationException(
      message: 'فشل في حفظ البيانات إلى التخزين المحلي',
      operation: 'write',
    ),
    'save': SharedPrefsOperationException(
      message: 'فشل في حفظ البيانات إلى التخزين المحلي',
      operation: 'write',
    ),
  };

  static final Map<Type, AppException Function(dynamic)> _typePatterns = {
    HiveError: (error) => HiveException(error: error.toString()),
    PlatformException: (error) =>
        SharedPrefsException(
          message: (error as PlatformException).code,
        ),
    MissingPluginException: (error) =>
        SharedPrefsException(
          message: (error as PlatformException).code,
        ),
    FirebaseException: (error) =>
        AppFirebaseException(
          message: (error as FirebaseException).message ?? 'خطأ في Firebase',
        ),
    SocketException: (error) =>
        AppNetworkException(
          message: 'لا يوجد اتصال بالإنترنت',
          connectivityService: connectivityService,
        ),
    TimeoutException: (error) =>
        AppNetworkException(
          message: 'انتهت المهلة، يرجى المحاولة مرة أخرى في وقت لاحق',
          connectivityService: connectivityService,
        ),
    FormatException: (error) =>
        AppClientException(
          message: 'تنسيق البيانات غير صالح',
        ),
  };

  Iterable<String> get keys => _stringPatterns.keys;

  bool isKey(dynamic error) => _typePatterns.containsKey(error);

  bool isSharedPrefsError() {
    final errorStr = error.toString().toLowerCase();
    return error is PlatformException &&
        (errorStr.contains('shared_preferences') ||
            errorStr.contains('sharedpreferences')) ||
        error is MissingPluginException &&
            errorStr.contains('shared_preferences') ||
        errorStr.contains('sharedpreferences') ||
        errorStr.contains('preferences') && errorStr.contains('instance');
  }

  AppException? mapByType() {
    final exception = _stringPatterns[error];
    if (exception != null) {
      return exception;
    }
    return null;
  }

  AppException? mapByStringPattern() {
    final exception = _typePatterns[error]!(error);
    return exception;
  }
}