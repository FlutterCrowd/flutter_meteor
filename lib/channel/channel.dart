import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meteor/engine/engine.dart';
import 'package:hz_tools/hz_tools.dart';

import '../event_bus/meteor_event_bus.dart';
import '../navigator/impl/flutter.dart';
import 'channel_method.dart';

class MeteorMethodChannel {
  static final MeteorFlutterNavigator _flutterNavigator = MeteorFlutterNavigator();

  MeteorMethodChannel() {
    methodChannel.setMethodCallHandler(
      (call) async {
        HzLog.t(
            'Meteor 原生调用flutter isMain:${MeteorEngine.isMain}  method:${call.method}, methodArguments:${call.arguments}');
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
          return await flutterPop(arguments: arguments);
        } else if (call.method == MeteorChannelMethod.popUntilMethod) {
          return await flutterPopUntil(arguments: arguments);
        } else if (call.method == MeteorChannelMethod.popToRootMethod) {
          return await flutterPopRoRoot(arguments: arguments);
        } else if (call.method == MeteorChannelMethod.pushNamedMethod) {
          return await flutterPushNamed(arguments: arguments);
        } else if (call.method == MeteorChannelMethod.multiEngineEventCallMethod) {
          String eventName = arguments['eventName'];
          List<MeteorEventBusListener> list = MeteorEventBus.listenersForEvent(eventName) ?? [];
          for (var listener in list) {
            listener.call(arguments['arguments']);
          }
        } else if (call.method == MeteorChannelMethod.routeExists) {
          String routeName = arguments['routeName'] ?? '';
          bool ret = await _flutterNavigator.routeExists(routeName);
          return ret;
        } else if (call.method == MeteorChannelMethod.isRoot) {
          String routeName = arguments['routeName'] ?? '';
          bool ret = await _flutterNavigator.isRoot(routeName);
          return ret;
        } else if (call.method == MeteorChannelMethod.rootRouteName) {
          String? ret = await _flutterNavigator.rootRouteName();
          return ret;
        } else if (call.method == MeteorChannelMethod.topRouteName) {
          String? ret = await _flutterNavigator.topRouteName();
          return ret;
        } else if (call.method == MeteorChannelMethod.routeNameStack) {
          List<String> routeNameStack = await _flutterNavigator.routeNameStack();
          // List<String> routeNameStack = MeteorFlutterNavigator.routeObserver.routeNameStack;
          return routeNameStack;
        } else {
          return null;
        }
      },
    );
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
