import 'package:flutter/foundation.dart';

class MeteorLog {
  static void error(String message) {
    if (kDebugMode) {
      print('[Meteor][Error]: $message');
    }
  }

  static void warning(String message) {
    if (kDebugMode) {
      print('[Meteor][Warning]: $message');
    }
  }

  static void info(String message) {
    if (kDebugMode) {
      print('[Meteor][Info]: $message');
    }
  }

  static void debug(String message) {
    // 在调试模式下打印
    if (kDebugMode) {
      print('[Meteor][Debug]: $message');
    }
  }
}
