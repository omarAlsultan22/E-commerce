import 'dart:io';
import 'dart:async';
import '../exceptions/firebase_exception.dart';
import '../exceptions/base/app_exception.dart';
import '../exceptions/validation_exception.dart';
import '../exceptions/components_exception.dart';
import '../exceptions/network_app_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../exceptions/cache_exceptions/hive_app_exceptions.dart';
import '../exceptions/cache_exceptions/shared_prefs_app_exceptions.dart';
import '../../domain/services/connectivity_service/connectivity_service.dart';
import 'package:international_cuisine/core/errors/exceptions/client_exception.dart';


class ExceptionMapper {
  final dynamic error;

  ExceptionMapper({required this.error});

  static final _connectivityService = ConnectivityService();
  static const String _msgServerError = 'Cannot reach the server';

  static final Map<String, AppException> _networkPatterns = {
    'socket': NetworkAppException(),
    'network': NetworkAppException(),
    'timeout': NetworkAppException(),
    'connection': NetworkAppException(),
    'host': NetworkAppException(message: _msgServerError),
    'dns': NetworkAppException(message: _msgServerError),
    'unable to resolve': NetworkAppException(message: _msgServerError),
  };

  static final Map<Object, AppException Function(dynamic)> _typePatterns = {
    HiveAppException: (error) => error,

    ValidationException: (error) => error,

    ComponentsException: (error) => error,

    SharedPrefsAppException: (error) => error,

    NetworkAppException: (error) => error,

    FirebaseException: (error) {
      final firebaseException = FirebaseAppException(
        message: (error as FirebaseException).message ?? 'خطأ في Firebase',
        error: error,
      );
      return firebaseException.handle();
    },
    SocketException: (_) =>
        NetworkAppException(
          connectivityService: _connectivityService,
        ),
    TimeoutException: (_) =>
        NetworkAppException(
          connectivityService: _connectivityService,
        ),
    FormatException: (_) =>
        ClientAppException(
          message: 'تنسيق البيانات غير صالح',
        ),
  };

  static final RegExp _mergedPatternRegex = RegExp(
    '(${[
      _networkPatterns.keys,
    ].join('|')})',
    caseSensitive: false,
  );

  Iterable<String> get keys => _networkPatterns.keys;

  bool get isKey => _typePatterns.containsKey(error);

  AppException? mapByTypePattern() {
    return _typePatterns[error]!(error);
  }

  AppException? mapByStringPattern() {
    final errorMessage = error.toString().toLowerCase();
    final match = _mergedPatternRegex.firstMatch(errorMessage);
    if (match != null) {
      final matchedKey = match.group(0)!;
      return _networkPatterns[matchedKey];
    }
    return null;
  }
}