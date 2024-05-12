import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../navigator/flutter/hz_flutter_navigater.dart';
import 'hz_router_plugin_platform_interface.dart';

class HzRouterPluginMethodChannel extends HzRouterPluginPlatform {
  static final HzFlutterNavigator _flutterNavigator = HzFlutterNavigator();

  HzRouterPluginMethodChannel() {
    methodChannel.setMethodCallHandler((call) async {
      Map<String, dynamic> arguments = <String, dynamic>{};
      if (call.arguments is Map) {
        Map res = call.arguments;
        res.forEach((key, value) {
          arguments[key.toString()] = value;
        });
      } else {
        arguments["arguments"] = call.arguments;
      }
      if (call.method == HzRouterPluginPlatform.hzPopMethod) {
        return flutterPop(arguments: arguments);
      } else if (call.method == HzRouterPluginPlatform.hzPopUntilMethod) {
        return flutterPopUntil(arguments: arguments);
      } else if (call.method == HzRouterPluginPlatform.hzPopToRootMethod) {
        return flutterPopRoRoot(arguments: arguments);
      } else if (call.method == HzRouterPluginPlatform.hzPushNamedMethod) {
        return flutterPushNamed(arguments: arguments);
      } else {
        return null;
      }
    });
  }

  /// The method channel used to interact with the native platform.
  final MethodChannel methodChannel =
      const MethodChannel('cn.itbox.router.multiEngine.methodChannel');

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
    debugPrint('Channel pop to root $arguments');
    return _flutterNavigator.popUntil(HzFlutterNavigator.rootRoute);
  }

  Future<dynamic> flutterPushNamed({Map<String, dynamic>? arguments}) async {
    Map<String, dynamic> arg = {};
    if (arguments != null) {
      arg.addAll(arguments);
    }
    String? routeName = arg["routeName"];
    if (routeName != null) {
      return await _flutterNavigator.pushNamed(routeName);
    }
  }

}
