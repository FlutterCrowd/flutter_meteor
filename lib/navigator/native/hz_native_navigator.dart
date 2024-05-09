import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hz_router/core/hz_router_interface.dart';

import 'hz_router_plugin_method_channel.dart';
import 'hz_router_plugin_platform_interface.dart';

/// 实现Native层页面路由
class HzNativeNavigator extends HzRouterInterface {
  final HzRouterPluginMethodChannel _pluginPlatform = HzRouterPluginMethodChannel();
  MethodChannel get methodChannel => _pluginPlatform.methodChannel;
  @override
  Future<T?> pushNamed<T extends Object?>(BuildContext? context,
      {required String routeName, Map<String, dynamic>? arguments}) async {
    Map<String, dynamic> params = {};
    params["routeName"] = routeName;
    if (arguments?['withNewEngine'] != null) {
      params["withNewEngine"] = arguments?['withNewEngine'];
      arguments?.remove('withNewEngine');
    }
    params["arguments"] = arguments;
    return await methodChannel.invokeMethod<T>(HzRouterPluginPlatform.hzPushNamedMethod, params);
  }

  @override
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(BuildContext? context,
      {required String routeName, String? untilRouteName, Map<String, dynamic>? arguments}) async {
    debugPrint('No implemented method name pushNamedAndRemoveUntil in native ');
    return null;
    return await methodChannel
        .invokeMethod<T>(HzRouterPluginPlatform.hzPushNamedAndRemoveUntilMethod);
  }

  @override
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(BuildContext? context,
      {required String routeName, Map<String, dynamic>? arguments}) async {
    debugPrint('No implemented method name pushReplacementNamed in native ');
    return null;
    return await methodChannel.invokeMethod<T>(HzRouterPluginPlatform.hzPushReplacementNamedMethod);
  }

  @override
  Future<T?> pop<T extends Object?>(BuildContext? context, {T? result}) async {
    return await methodChannel.invokeMethod<T>(HzRouterPluginPlatform.hzPopMethod);
  }

  @override
  Future<T?> popToRoot<T extends Object?>(BuildContext? context) async {
    return await methodChannel.invokeMethod<T>(HzRouterPluginPlatform.hzPopToRootMethod);
  }

  @override
  Future<T?> popUntil<T extends Object?>(BuildContext? context, {required String routeName}) async {
    debugPrint('No implemented method name popUntil in native ');
    return null;
    return await _pluginPlatform.methodChannel
        .invokeMethod<T>(HzRouterPluginPlatform.hzPopUntilMethod);
  }

  // @override
  // Future<T?> pushNamed<T extends Object?>(BuildContext? context,
  //     {required String routeName, Map<String, dynamic>? arguments}) async {
  //   return await _pluginPlatform.pushNamed<T>(routeName: routeName);
  // }
  //
  // @override
  // Future<T?> pushNamedAndRemoveUntil<T extends Object?>(BuildContext? context,
  //     {required String routeName, String? untilRouteName, Map<String, dynamic>? arguments}) async {
  //   return await _pluginPlatform.pushNamedAndRemoveUntil<T>(routeName: routeName);
  // }
  //
  // @override
  // Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(BuildContext? context,
  //     {required String routeName, Map<String, dynamic>? arguments}) async {
  //   return await _pluginPlatform.pushReplacementNamed<T>(routeName: routeName);
  // }
  //
  // @override
  // Future<T?> pop<T extends Object?>(BuildContext? context, {T? result}) async {
  //   return await _pluginPlatform.pop(result: result);
  // }
  //
  // @override
  // Future<T?> popToRoot<T extends Object?>(BuildContext? context) async {
  //   return await _pluginPlatform.popToRoot();
  // }
  //
  // @override
  // Future<T?> popUntil<T extends Object?>(BuildContext? context, {required String routeName}) async {
  //   return await _pluginPlatform.popUntil(routeName: routeName);
  // }
}
