import 'package:flutter/foundation.dart';

import 'utils/navigation_utils.dart';

void onFlutterError(FlutterErrorDetails details) async {
  if (kDebugMode) {
    FlutterError.presentError(details);
  }
  if (details.library == "widgets library") {
    navigateToNamed('/generic_error');
  }
  debugPrintStack(stackTrace: details.stack);
}
