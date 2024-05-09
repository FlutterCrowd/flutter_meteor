import 'package:flutter/services.dart';
import 'package:hz_router/navigator/hz_navigator.dart';

import '../flutter/hz_flutter_navigater.dart';
import 'hz_router_plugin_platform_interface.dart';

/// An implementation of [HzRouterPluginPlatform] that uses method channels.
class HzRouterPluginMethodChannel extends HzRouterPluginPlatform {
  static final HzFlutterNavigator _flutterNavigator =
      HzFlutterNavigator(naviKey: HzNavigator.naviKey);

  HzRouterPluginMethodChannel() {
    methodChannel.setMethodCallHandler((call) async {
      if (call.method == HzRouterPluginPlatform.hzPopMethod) {
        return flutterPop(arguments: call.arguments);
      } else if (call.method == HzRouterPluginPlatform.hzPopUntilMethod) {
        return flutterPopUntil(arguments: call.arguments);
      } else if (call.method == HzRouterPluginPlatform.hzPopToRootMethod) {
        return flutterPopRoRoot(arguments: call.arguments);
      } else if (call.method == HzRouterPluginPlatform.hzPushNamedMethod) {
        return flutterPushNamed(arguments: call.arguments);
      } else {
        return Future<void>.value();
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
      return await _flutterNavigator.popUntil(null, routeName: routeName);
    } else {
      return await _flutterNavigator.pop(null);
    }
  }

  Future<dynamic> flutterPopRoRoot({Map<String, dynamic>? arguments}) async {
    return _flutterNavigator.popToRoot(null);
  }

  Future<dynamic> flutterPushNamed({Map<String, dynamic>? arguments}) async {
    Map<String, dynamic> arg = {};
    if (arguments != null) {
      arg.addAll(arguments);
    }
    String? routeName = arg["routeName"];
    if (routeName != null) {
      return await _flutterNavigator.pushNamed(null, routeName: routeName);
    }
  }

  /// ***********Flutter to native*************/
  // @override
  // Future<T?> pushNamed<T extends Object?>(
  //     {required String routeName, Map<String, dynamic>? arguments}) async {
  //   Map<String, dynamic> params = {};
  //   params["routeName"] = routeName;
  //   params["arguments"] = arguments;
  //   return await methodChannel.invokeMethod<T>(HzRouterPluginPlatform.hzPushNamedMethod, params);
  // }

  // @override
  // Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
  //     {required String routeName, String? untilRouteName, Map<String, dynamic>? arguments}) async {
  //   debugPrint('No implemented method name pushNamedAndRemoveUntil in native ');
  //   return null;
  //   return await methodChannel
  //       .invokeMethod<T>(HzRouterPluginPlatform.hzPushNamedAndRemoveUntilMethod);
  // }

  // @override
  // Future<T?> pushReplacementNamed<T extends Object?>(
  //     {required String routeName, Map<String, dynamic>? arguments}) async {
  //   debugPrint('No implemented method name pushReplacementNamed in native ');
  //   return null;
  //   return await methodChannel.invokeMethod<T>(HzRouterPluginPlatform.hzPushReplacementNamedMethod);
  // }

  // @override
  // Future<T?> pop<T extends Object?>({T? result}) async {
  //   return await methodChannel.invokeMethod<T>(HzRouterPluginPlatform.hzPopMethod);
  // }

  // @override
  // Future<T?> popToRoot<T extends Object?>() async {
  //   return await methodChannel.invokeMethod<T>(HzRouterPluginPlatform.hzPopToRootMethod);
  // }
  //
  // @override
  // Future<T?> popUntil<T extends Object?>({required String routeName}) async {
  //   debugPrint('No implemented method name popUntil in native ');
  //   return null;
  //   return await methodChannel.invokeMethod<T>(HzRouterPluginPlatform.hzPopUntilMethod);
  // }
}
