import 'package:flutter/services.dart';
import 'package:flutter_meteor/engine/engine.dart';
import 'package:hz_tools/hz_tools.dart';

import '../event_bus/meteor_event_bus.dart';
import '../navigator/impl/flutter.dart';
import 'channel_method.dart';

class MeteorMethodChannel {
  static final MeteorFlutterNavigator _flutterNavigator = MeteorFlutterNavigator();

  MeteorMethodChannel() {
    methodChannel.setMethodCallHandler((call) async {
      HzLog.t(
          'MeteorMethodChannel isMain:${MeteorEngine.isMain}  method:${call.method}, methodArguments:${call.arguments}');
      Map<String, dynamic> arguments = <String, dynamic>{};
      if (call.arguments is Map) {
        Map res = call.arguments;
        res.forEach((key, value) {
          arguments[key.toString()] = value;
        });
      } else {
        arguments["arguments"] = call.arguments;
      }
      if (call.method == MeteorChannelMethod.popMethod) {
        return flutterPop(arguments: arguments);
      } else if (call.method == MeteorChannelMethod.popUntilMethod) {
        return flutterPopUntil(arguments: arguments);
      } else if (call.method == MeteorChannelMethod.popToRootMethod) {
        return flutterPopRoRoot(arguments: arguments);
      } else if (call.method == MeteorChannelMethod.pushNamedMethod) {
        return flutterPushNamed(arguments: arguments);
      } else if (call.method == MeteorChannelMethod.multiEngineEventCallMethod) {
        String eventName = arguments['eventName'];
        List<MeteorEventBusListener> list = MeteorEventBus.listenersForEvent(eventName) ?? [];
        for (var listener in list) {
          listener.call(arguments['arguments']);
        }
        HzLog.i(
            'MeteorMethodChannel isMain:${MeteorEngine.isMain} method:${call.method}, eventName:$eventName, arguments:${arguments['arguments']}');
      } else {
        return null;
      }
    });
  }

  /// The method channel used to interact with the native platform.
  final MethodChannel methodChannel = const MethodChannel('itbox.meteor.channel');

  /// ***********Native to flutter*************/
  Future<dynamic> flutterPop({Map<String, dynamic>? arguments}) async {
    return await _flutterNavigator.pop(null);
  }

  Future<dynamic> flutterPopUntil({Map<String, dynamic>? arguments}) async {
    Map<String, dynamic> arg = {};
    if (arguments != null) {
      arg.addAll(arguments);
    }
    String? routeName = arg["routeName"];
    if (routeName != null) {
      return await _flutterNavigator.popUntil(routeName);
    } else {
      return await _flutterNavigator.pop(null);
    }
  }

  Future<dynamic> flutterPopRoRoot({Map<String, dynamic>? arguments}) async {
    HzLog.i('Channel flutterPopRoRoot arguments: $arguments');
    return _flutterNavigator.popToFirstRoute();
  }

  Future<dynamic> flutterPushNamed({Map<String, dynamic>? arguments}) async {
    Map<String, dynamic> arg = {};
    if (arguments != null) {
      arg.addAll(arguments);
    }
    String? routeName = arg["routeName"];
    HzLog.t('Channel flutterPushNamed arguments: $arguments');
    if (routeName != null) {
      return await _flutterNavigator.pushNamed(routeName);
    }
  }
}
