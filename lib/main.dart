import 'dart:io';
import 'app/my_app.dart';
import 'package:flutter/material.dart';
import 'core/config/firebase_options.dart';
import 'core/data/data_sources/local/hive.dart';
import 'core/errors/mappers/error_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/data/data_sources/local/shared_preferences.dart';
import 'core/domain/services/connectivity_service/connectivity_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final _hiveStore = HiveStore();
  final _cacheHelper = CacheHelper();
  final _connectivityService = ConnectivityService();

  try {
    await _hiveStore.init();
    await _cacheHelper.init();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final _hasInternet = await _connectivityService.checkInternetConnection();

    if (!_hasInternet) {
      throw SocketException;
    }

    runApp(MyApp());
  } catch (e, stackTrace) {
    final errorHandler = ErrorHandler(
      error: e,
      stackTrace: stackTrace,
    );
    final exception = errorHandler.handleException();
    runApp(
        MaterialApp(
            debugShowCheckedModeBanner: false,
            home: exception.buildErrorWidget(
                onRetry: () => runApp(const MyApp())
            )
        )
    );
  }
}

