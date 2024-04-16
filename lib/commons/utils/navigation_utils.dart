import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<T?>? navigateToNamed<T>(
  String route, {
  dynamic arguments,
  Map<String, String>? parameters,
}) {
  return navigatorKey.currentState?.pushNamed<T>(
    route,
    arguments: arguments,
  );
}
