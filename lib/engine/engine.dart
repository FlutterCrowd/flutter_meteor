import 'dart:convert';

import 'package:flutter_meteor/engine/entry_args.dart';
import 'package:hz_tools/hz_tools.dart';

class MeteorEngine {
  MeteorEngine._();

  static bool _isMain = true;
  static get isMain => _isMain;

  static String? engineId = 'mainEngine';

  static EntryArguments parseEntryArgs(List<String>? args) {
    HzLog.d('EntryArguments parseEntryArgs args:$args');
    _isMain = false;
    if (args == null || args.isEmpty) {
      HzLog.w('EntryArguments is null');
      return EntryArguments('/', null);
    }
    final jsonObject = args.isNotEmpty ? jsonDecode(args.first) : {};
    String initialRoute = jsonObject['initialRoute'] ?? '/';
    engineId = jsonObject['engineId'];
    Map<String, dynamic>? routeArguments = jsonObject['routeArguments'];
    HzLog.t(
        'EntryArguments parseEntryArgs initialRoute:$initialRoute, routeArguments:$routeArguments');
    return EntryArguments(initialRoute, routeArguments);
  }
}
