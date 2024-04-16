import 'package:flutter/material.dart';

import '../../presentation/presentation.dart';


class AppRoutes {
  static const String home = '/';
  static const String splash = '/splash';
  static const String genericError = '/generic_error';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const MapScreen());
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      default:
        return MaterialPageRoute(builder: (_) => const ErrorScreen());
    }
  }
}
