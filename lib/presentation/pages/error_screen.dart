import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:map_app_flutter/commons/routes/app_routes.dart';
import 'package:map_app_flutter/commons/utils/navigation_utils.dart';

class ErrorScreen extends StatefulWidget {
  const ErrorScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    final String? errorMessage =
        ModalRoute.of(context)?.settings.arguments as String?;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            navigateToNamed(AppRoutes.home);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              "assets/error.json",
              repeat: true,
              animate: true,
              reverse: false,
            ),
            const SizedBox(height: 20),
            Text(
              errorMessage ??
                  'Ops, encontramos um erro! Tente novamente mais tarde',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
