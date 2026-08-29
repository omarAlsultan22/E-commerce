import 'dart:io';
import 'dart:async';
import '../exceptions/firebase_exception.dart';
import '../exceptions/base/app_exception.dart';
import '../exceptions/network_app_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:international_cuisine/core/constants/app_strings.dart';
import '../../domain/services/connectivity_service/connectivity_service.dart';
import 'package:international_cuisine/core/errors/exceptions/client_exception.dart';


class ExceptionMapper {
  final dynamic error;

  ExceptionMapper({required this.error});

  static final _connectivityService = ConnectivityService();
  static const _noInternetMessage = AppStrings.noInternetMessage;
  static const String _msgServerError = 'Cannot reach the server';

  static final Map<String, AppException> _networkPatterns = {
    'socket': NetworkAppException(message: _noInternetMessage),
    'connection': NetworkAppException(message: _noInternetMessage),
    'network': NetworkAppException(message: _noInternetMessage),
    'timeout': NetworkAppException(message: _noInternetMessage),
    'host': NetworkAppException(message: _msgServerError),
    'dns': NetworkAppException(message: _msgServerError),
    'unable to resolve': NetworkAppException(message: _msgServerError),
  };

  static final Map<Object, AppException Function(dynamic)> _typePatterns = {
    FirebaseException: (error) {
      final firebaseException = FirebaseAppException(
        message: (error as FirebaseException).message ?? 'خطأ في Firebase',
        error: error,
      );
      return firebaseException.handle();
    },
    SocketException: (error) =>
        NetworkAppException(
          message: _noInternetMessage,
          connectivityService: _connectivityService,
        ),
    TimeoutException: (error) =>
        NetworkAppException(
          message: 'انتهت المهلة، يرجى المحاولة مرة أخرى في وقت لاحق',
          connectivityService: _connectivityService,
        ),
    FormatException: (error) =>
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