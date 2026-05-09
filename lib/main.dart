import 'app/my_app.dart';
import 'package:flutter/material.dart';
import 'core/config/firebase_options.dart';
import 'core/data/data_sources/local/hive.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/data/data_sources/local/shared_preferences.dart';
import 'core/presentation/widgets/internet_unavailability.dart';
import 'core/domain/services/connectivity_service/connectivity_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final _cacheHelper = CacheHelper();
  final _hiveStore = HiveStore();

  try {
    await _cacheHelper.init();
    await _hiveStore.init();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final _connectivityService = ConnectivityService();
    final _hasInternet = await _connectivityService.checkInternetConnection();

    if (!_hasInternet) {
      throw Exception();
    }

    runApp(MyApp());
  } catch (e) {
    runApp(InternetUnavailability(onRetry: () => MyApp()));
  }
}

