import 'dart:convert';

import 'package:flutter_meteor/engine/entry_args.dart';

class MeteorEngine {
  MeteorEngine._();

  static bool _isMain = true;
  static get isMain => _isMain;

  static EntryArguments parseEntryArgs(List<String>? args) {
    _isMain = false;
    if (args == null || args.isEmpty) {
      return EntryArguments('/', null);
    }
    final jsonObject = args.isNotEmpty ? jsonDecode(args.first) : {};
    String initialRoute = jsonObject['initialRoute'] ?? '/';
    Map<String, dynamic>? routeArguments = jsonObject['routeArguments'];
    return EntryArguments(initialRoute, routeArguments);
  }
}
