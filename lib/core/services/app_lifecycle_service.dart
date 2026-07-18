import 'package:flutter/material.dart';
import '../navigation/navigation_keys.dart';
import '../../features/cart/presentation/cubits/cart_data_cubit.dart';


class AppLifecycleService extends WidgetsBindingObserver {
  static AppLifecycleService? _instance;

  factory AppLifecycleService() {
    _instance ??= AppLifecycleService._internal();
    return _instance!;
  }

  AppLifecycleService._internal() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      await _saveCart();
    }
  }

  Future<void> _saveCart() async {
    try {
      final context = NavigationKeys.context;
      if (context != null) {
        await CartDataCubit.get(context).saveCartToHive();
      }
    } catch (e) {
      debugPrint('❌ Error saving cart: $e');
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}