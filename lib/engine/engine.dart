import 'dart:convert';

import 'package:flutter_meteor/engine/entry_args.dart';
import 'package:hz_tools/hz_tools.dart';

class MeteorEngine {
  MeteorEngine._();

  static bool _isMain = false;
  static get isMain => _isMain;

  static EntryArguments parseEntryArgs(List<String>? args) {
    HzLog.d('EntryArguments parseEntryArgs args:$args');
    _isMain = false;
    if (args == null || args.isEmpty) {
      HzLog.w('EntryArguments is null');
      return EntryArguments(null, null);
    }
    final jsonObject = args.isNotEmpty ? jsonDecode(args.first) : {};
    String? initialRoute = jsonObject['initialRoute'];
    Map<String, dynamic>? routeArguments = jsonObject['routeArguments'];
    _isMain = jsonObject['isMain'] as bool? ?? false;
    HzLog.t(
        'EntryArguments parseEntryArgs initialRoute:$initialRoute, routeArguments:$routeArguments');
    return EntryArguments(initialRoute, routeArguments);
  }
}
