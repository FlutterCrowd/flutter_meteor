import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hz_router/core/hz_router_interface.dart';

import '../../core/plugin/hz_router_plugin_method_channel.dart';
import '../../core/plugin/hz_router_plugin_platform_interface.dart';

/// 实现Native层页面路由
class HzNativeNavigator extends HzRouterInterface {
  final HzRouterPluginMethodChannel _pluginPlatform = HzRouterPluginMethodChannel();

  MethodChannel get methodChannel => _pluginPlatform.methodChannel;

  @override
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    bool withNewEngine = false,
    bool newEngineOpaque = true,
    bool openNative = false,
    Map<String, dynamic>? arguments,
  }) async {
    Map<String, dynamic> params = {};
    params["routeName"] = routeName;
    params["withNewEngine"] = withNewEngine;
    params["newEngineOpaque"] = newEngineOpaque;
    params["openNative"] = openNative;
    params["arguments"] = arguments;
    return await methodChannel.invokeMethod<T>(HzRouterPluginPlatform.hzPushNamedMethod, params);
  }

  @override
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    String untilRouteName, {
    Map<String, dynamic>? arguments,
  }) async {
    debugPrint('No implemented method name pushNamedAndRemoveUntil in native ');
    return null;
  }

  @override
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    Map<String, dynamic>? arguments,
  }) async {
    debugPrint('No implemented method name pushReplacementNamed in native ');
    return null;
  }

  @override
  Future<T?> pop<T extends Object?>([T? result]) async {
    await methodChannel.invokeMethod(HzRouterPluginPlatform.hzPopMethod, result);
    return null;
  }

  @override
  Future<T?> popToRoot<T extends Object?>() async {
    return await methodChannel.invokeMethod<T>(HzRouterPluginPlatform.hzPopToRootMethod);
  }

  @override
  Future<T?> popUntil<T extends Object?>(String routeName) async {
    debugPrint('No implemented method name popUntil in native ');
    return null;
  }

  @override
  Future<T?> popUntilLastNative<T extends Object?>() async {
    return await methodChannel.invokeMethod<T>(HzRouterPluginPlatform.hzPopMethod);
  }

  @override
  Future<T?> dismiss<T extends Object?>([T? result]) async {
    if (Platform.isIOS) {
      return await methodChannel.invokeMethod<T>(HzRouterPluginPlatform.hzDismissMethod);
    } else {
      return await methodChannel.invokeMethod<T>(HzRouterPluginPlatform.hzPopMethod);
    }
  }
}
