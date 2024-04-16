import 'dart:io';

import 'package:flutter/foundation.dart';

class PlatformUtils {
  static bool get isMobile {
    return !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  }

  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  static bool get isIOS => !kIsWeb && Platform.isIOS;
}
