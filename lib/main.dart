import 'app/my_app.dart';
import 'package:flutter/material.dart';
import 'core/config/firebase_options.dart';
import 'core/data/data_sources/local/hive.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/data/data_sources/local/shared_preferences.dart';
import 'core/domain/services/connectivity_service/connectivity_service.dart';
import 'core/presentation/screens/internet_unavailability_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await CacheHelper.init();
    await HiveStore.init();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final _hasInternet = await ConnectivityService.checkInternetConnection();
    if (!_hasInternet) {
      throw Exception();
    }

    runApp(MyApp());
  } catch (e) {
    runApp(InternetUnavailabilityScreen(onRetry: () => MyApp()));
  }
}


