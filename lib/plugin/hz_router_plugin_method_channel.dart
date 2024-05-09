import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hz_router/core/hz_navigator.dart';

import 'hz_router_plugin_platform_interface.dart';

/// An implementation of [HzRouterPluginPlatform] that uses method channels.
class MethodChannelHzRouterPlugin extends HzRouterPluginPlatform {
  MethodChannelHzRouterPlugin(
      {this.methodChannel = const MethodChannel('cn.itbox.router.multi_engine.methodChannel')}) {
    methodChannel.setMethodCallHandler((call) async {
      if (call.method == 'pop') {
        flutterPop(arguments: call.arguments);
      } else if (call.method == 'popToRoot') {
        flutterPopRoRoot(arguments: call.arguments);
      }
      return <String, dynamic>{};
    });
  }

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  // final methodChannel = const MethodChannel('hz_router_plugin');
  final MethodChannel methodChannel;

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<Map<String, dynamic>?> pop({Map<String, dynamic>? arguments}) async {
    dynamic res = await methodChannel.invokeMethod("pop", arguments) ?? {};
    if (res is Map) {
      Map<String, dynamic> response = {};
      res.forEach((key, value) {
        response[key.toString()] = value;
      });
      return response;
    }
    return {};
  }

  @override
  Future<Map<String, dynamic>?> popToRoot({Map<String, dynamic>? arguments}) async {
    dynamic res = await methodChannel.invokeMethod("popToRoot", arguments) ?? {};
    if (res is Map) {
      Map<String, dynamic> response = {};
      res.forEach((key, value) {
        response[key.toString()] = value;
      });
      return response;
    }
    return {};
  }

  @override
  Future<Map<String, dynamic>?> push(
      {required String routerName, Map<String, dynamic>? arguments}) async {
    Map<String, dynamic> arg = {};
    if (arguments != null) {
      arg.addAll(arguments);
    }
    arg["routerName"] = routerName;
    dynamic res = await methodChannel.invokeMethod("push", arg) ?? {};
    if (res is Map) {
      Map<String, dynamic> response = {};
      res.forEach((key, value) {
        response[key.toString()] = value;
      });
      return response;
    }
    return {};
  }

  Future<void> flutterPop({Map<String, dynamic>? arguments}) async {
    Map<String, dynamic> arg = {};
    if (arguments != null) {
      arg.addAll(arguments);
    }
    String? routerName = arg["routerName"];
    if (routerName != null) {
      return HzNavigator.popUntil(null, routeName: routerName);
    } else {
      return HzNavigator.pop(null);
    }
  }

  Future<void> flutterPopRoRoot({Map<String, dynamic>? arguments}) async {
    return HzNavigator.popToRoot(null);
  }
}
