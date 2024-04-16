import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:map_app_flutter/commons/commons.dart';

class DefaultApp extends StatefulWidget {
  const DefaultApp({
    Key? key,
  }) : super(key: key);

  @override
  State<DefaultApp> createState() => _DefaultAppState();
}

class _DefaultAppState extends State<DefaultApp> {
  @override
  void initState() {
    super.initState();
    removeNativeSplash();
  }

  @override
  Widget build(BuildContext context) {
    return DependencyProvider(
      container: DependencyContainer(),
      child: MaterialApp(
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              color: Colors.white,
              elevation: 0,
            ),
            scaffoldBackgroundColor: Colors.white,
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRoutes.generateRoute,),
    );
  }

  void removeNativeSplash() async {
    await Future.delayed(const Duration(seconds: 2));
    FlutterNativeSplash.remove();
  }
}
