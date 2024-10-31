import 'dart:convert';

import 'package:flutter_meteor/engine/entry_args.dart';

export 'entry_args.dart';

class MeteorEngine {
  MeteorEngine._();

  static EntryArguments parseEntryArgs(List<String>? args) {
    if (args == null || args.isEmpty) {
      return EntryArguments(null, null);
    }
    final jsonObject = args.isNotEmpty ? jsonDecode(args.first) : {};
    String? initialRoute = jsonObject['initialRoute'];
    Map<String, dynamic>? routeArguments = jsonObject['routeArguments'];
    return EntryArguments(initialRoute, routeArguments);
  }
}
