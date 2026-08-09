import 'firebase_options.dart';
import '../di/service _locator.dart';
import '../data/data_sources/local/hive.dart';
import 'package:firebase_core/firebase_core.dart';
import '../data/data_sources/local/shared_preferences.dart';


class InitializationController {
  static final InitializationController _instance =
  InitializationController._internal();

  factory InitializationController() => _instance;

  InitializationController._internal();

  late final HiveStore _hiveStore;
  late final CacheHelper _cacheHelper;

  bool _isInitialized = false;

  Future<void> _initializeServices() async {
    await Future.wait<void>([
      _hiveStore.init(),
      _cacheHelper.init(),
      Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
    ]);
  }

  Future<void> init() async {
    if (_isInitialized) return;

    _hiveStore = sl<HiveStore>();
    _cacheHelper = sl<CacheHelper>();

    await _initializeServices();

    _isInitialized = true;
  }

  Future<void> retryInit() async {
    await _initializeServices();
  }
}