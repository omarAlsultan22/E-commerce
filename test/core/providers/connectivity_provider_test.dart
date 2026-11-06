import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:connectivity_plus/connectivity_plus.dart';


class ConnectivityProvider with ChangeNotifier {
  // المتغيرات الأساسية
  bool _online = false;
  bool _offline = false;
  bool _isConnected = false;
  bool _isInitialized = false;
  String _connectionType = 'Unknown';

  // الـ Subscriptions والـ Timers
  StreamSubscription<List<ConnectivityResult>>? connectivitySubscription;
  Timer? _onlineTimer;
  Timer? _offlineTimer;
  Timer? _checkTimer;

  static const _none = 'None';

  // Getters
  bool get online => _online;

  bool get offline => _offline;

  bool get isConnected => _isConnected;

  final Connectivity _connectivity = Connectivity();

  static ConnectivityProvider? _instance;

  factory ConnectivityProvider() {
    _instance ??= ConnectivityProvider._internal();
    return _instance!;
  }

  ConnectivityProvider._internal({bool autoStart = true}) {
    if (autoStart) {
      _initConnectivity();
      _startPeriodicCheck();
    }
  }

  // ==================== التهيئة ====================


  void _initConnectivity() async {
    try {
      // التحقق من الحالة الأولية
      final result = await _connectivity.checkConnectivity();
      final bool initialStatus = hasConnection(result);
      final String initialType = getConnectionType(result);

      // تحديث القيم مباشرة
      _isConnected = initialStatus;
      _connectionType = initialType;
      _isInitialized = true;

      // إشعار واحد فقط بعد التهيئة
      notifyListeners();

      // عرض الرسالة المناسبة بعد التأكد من الحالة
      if (_isConnected) {
        _showOnline();
      } else {
        _showOffline();
      }

      // بدء الاستماع للتغيرات
      connectivitySubscription = listenToStatus(updateConnectionStatus);
    } catch (e) {
      print('Error initializing connectivity: $e');
      _isConnected = false;
      _connectionType = _none;
      _isInitialized = true;
      notifyListeners();

      _showOffline();
    }
  }

  @visibleForTesting
  void setConnectedForTesting(bool value) {
    _isConnected = value;
  }

  // ==================== التحقق من الاتصال ====================

  Future<void> _checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      updateConnectionStatus(result);
    } catch (e) {
      print('Error checking connectivity: $e');
      updateConnectionStatus([ConnectivityResult.none]);
    }
  }

  // ==================== الاستماع للتغيرات ====================

  StreamSubscription<List<ConnectivityResult>> listenToStatus(
      void Function(List<ConnectivityResult> event) onData) {
    return _connectivity.onConnectivityChanged.listen(
      onData,
      onError: (error) {
        print('Connectivity error: $error');
        updateConnectionStatus([ConnectivityResult.none]);
      },
    );
  }

  // ==================== الفحص الدوري ====================

  void _startPeriodicCheck() {
    // فحص دوري كل 10 ثوان للتأكد من الاتصال
    _checkTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      await _checkConnectivity();
    });
  }

  // ==================== تحديث حالة الاتصال ====================

  void updateConnectionStatus(List<ConnectivityResult> results) {
    // تجاهل التحديثات قبل التهيئة
    if (!_isInitialized) return;

    final bool newStatus = hasConnection(results);
    final String newType = getConnectionType(results);

    print('Connection status: $newStatus, Type: $newType');

    if (_isConnected != newStatus || _connectionType != newType) {
      final bool wasConnected = _isConnected;
      _isConnected = newStatus;
      _connectionType = newType;

      if (wasConnected && !newStatus) {
        // فقدان الاتصال
        print('Connection lost');
        _hideOnline();
        _showOffline();
        _notifyWithDelay();
      } else if (!wasConnected && newStatus) {
        // استعادة الاتصال
        print('Connection restored');
        _hideOffline();
        _showOnline();
        notifyListeners();
        _tryReloadData();
      } else {
        // تغيير في نوع الاتصال فقط
        notifyListeners();
      }
    }
  }

  // ==================== دوال المساعدة ====================

  @visibleForTesting
  factory ConnectivityProvider.forTesting() =>
      ConnectivityProvider._internal(autoStart: false);

  /// للاختبار فقط: يوقف الـ Singleton ويسمح بإنشاء نسخة جديدة.
  @visibleForTesting
  static void resetForTesting() {
    _instance!.dispose();
    _instance = null;
  }

  // ... (باقي الكود كما هو، مع استبدال _hasConnection → hasConnection
  //      و _getConnectionType → getConnectionType)

  @visibleForTesting
  bool hasConnection(List<ConnectivityResult> results) {
    if (results.isEmpty) return false;

    for (var result in results) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet ||
          result == ConnectivityResult.vpn ||
          result == ConnectivityResult.other) {
        return true;
      }
    }
    return false;
  }

  @visibleForTesting
  String getConnectionType(List<ConnectivityResult> results) {
    if (results.isEmpty) return _none;

    if (results.contains(ConnectivityResult.wifi)) return 'WiFi';
    if (results.contains(ConnectivityResult.mobile)) return 'Mobile Data';
    if (results.contains(ConnectivityResult.ethernet)) return 'Ethernet';
    if (results.contains(ConnectivityResult.vpn)) return 'VPN';
    if (results.contains(ConnectivityResult.other)) return 'Other';

    return _none;
  }

  // ==================== عرض وإخفاء الحالات ====================

  void _showOnline() {
    _onlineTimer?.cancel();
    _online = true;
    notifyListeners();

    _onlineTimer = Timer(const Duration(seconds: 5), () {
      _online = false;
      notifyListeners();
    });
  }

  void _showOffline() {
    _offlineTimer?.cancel();
    _offline = true;
    notifyListeners();

    _offlineTimer = Timer(const Duration(seconds: 5), () {
      _offline = false;
      notifyListeners();
    });
  }

  void _hideOnline() {
    _onlineTimer?.cancel();
    _online = false;
    notifyListeners();
  }

  void _hideOffline() {
    _offlineTimer?.cancel();
    _offline = false;
    notifyListeners();
  }

  // ==================== دوال إضافية ====================

  void _notifyWithDelay() {
    // تأخير صغير للتأكد من أن UI قد استقبل التحديث
    Future.delayed(const Duration(milliseconds: 300), () {
      notifyListeners();
    });
  }

  void _tryReloadData() {
    // محاولة إعادة تحميل البيانات بعد استعادة الاتصال
    Future.delayed(const Duration(seconds: 2), () {
      // يمكنك هنا استدعاء دالة لإعادة تحميل البيانات
      print('Attempting to reload data...');

      // مثال: إذا كان لديك Cubit أو Provider للبيانات
      // context.read<TodaysNewsCubit>().loadData();
    });
  }

  // ==================== تحديث يدوي ====================

  Future<void> refreshConnection() async {
    // تحديث يدوي لحالة الاتصال
    await _checkConnectivity();
  }

  // ==================== تنظيف الموارد ====================

  @override
  void dispose() {
    connectivitySubscription?.cancel();
    _onlineTimer?.cancel();
    _offlineTimer?.cancel();
    _checkTimer?.cancel();
    super.dispose();
  }
}