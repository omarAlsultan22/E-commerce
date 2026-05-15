import 'dart:io';
import 'dart:async';
import 'package:hive/hive.dart';
import 'package:flutter/services.dart';
import '../exceptions/firebase_exception.dart';
import '../exceptions/base/app_exception.dart';
import '../exceptions/network_app_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../exceptions/cache_exceptions/hive_app_exceptions.dart';
import '../exceptions/cache_exceptions/shared_prefs_app_exceptions.dart';
import '../../domain/services/connectivity_service/connectivity_service.dart';
import 'package:international_cuisine/core/errors/exceptions/client_exception.dart';


class ExceptionMapper {
  final dynamic error;

  ExceptionMapper({required this.error});

  static final connectivityService = ConnectivityService();
  static const String _msgCastError = 'خطأ في نوع البيانات المخزنة';
  static const String _msgInitError = 'لم تتم تهيئة التخزين المحلي بشكل صحيح';
  static const String _msgReadError = 'فشل في قراءة البيانات من التخزين المحلي';
  static const String _msgWriteError = 'فشل في حفظ البيانات إلى التخزين المحلي';

  static final Map<String, AppException> _stringPatterns = {
    '_casterror': SharedPrefsCastException(
      message: _msgCastError,
    ),
    'null check operator': SharedPrefsCastException(
      message: _msgCastError,
    ),
    'getinstance': SharedPrefsInitException(
      message: _msgInitError,
    ),
    'not initialized': SharedPrefsInitException(
      message: _msgInitError,
    ),
    'binding has not been initialized': SharedPrefsInitException(
      message: _msgInitError,
    ),
    'read': SharedPrefsOperationException(
      message: _msgReadError,
      operation: 'read',
    ),
    'get': SharedPrefsOperationException(
      message: _msgReadError,
      operation: 'read',
    ),
    'write': SharedPrefsOperationException(
      message: _msgWriteError,
      operation: 'write',
    ),
    'set': SharedPrefsOperationException(
      message: _msgWriteError,
      operation: 'write',
    ),
    'save': SharedPrefsOperationException(
      message: _msgWriteError,
      operation: 'write',
    ),
  };

  static final Map<Type, AppException Function(dynamic)> _typePatterns = {
    HiveError: (error) {
      final hiveException = HiveAppException(error: error.toString());
      return hiveException.getException();
    },
    PlatformException: (error) {
      final prefsException = SharedPrefsAppException(
        message: (error as PlatformException).code,
        error: error,
      );
      return prefsException.getException();
    },
    MissingPluginException: (error) =>
        SharedPrefsAppException(
          message: (error as PlatformException).code,
        ),
    FirebaseException: (error) {
      final firebaseException = FirebaseAppException(
        message: (error as FirebaseException).message ?? 'خطأ في Firebase',
        error: error,
      );
      return firebaseException.getException();
    },
    SocketException: (error) =>
        NetworkAppException(
          message: 'لا يوجد اتصال بالإنترنت',
          connectivityService: connectivityService,
        ),
    TimeoutException: (error) =>
        NetworkAppException(
          message: 'انتهت المهلة، يرجى المحاولة مرة أخرى في وقت لاحق',
          connectivityService: connectivityService,
        ),
    FormatException: (error) =>
        ClientAppException(
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