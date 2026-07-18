import 'package:flutter/material.dart';
import 'package:international_cuisine/features/cart/presentation/cubits/cart_data_cubit.dart';


mixin CartPersistenceMixin<T extends StatefulWidget> on State<T> implements WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
      CartDataCubit.get(context).saveCartToHive();
    } catch (e) {
      // Handle error if needed
    }
  }
}