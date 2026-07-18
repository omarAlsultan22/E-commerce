import 'package:flutter/material.dart';


class NavigationKeys {
  NavigationKeys._();

  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static BuildContext? get context => navigatorKey.currentContext;
}

