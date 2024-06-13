import 'dart:io';

import 'package:flutter/services.dart';
import 'package:hz_tools/hz_tools.dart';

import '../../channel/channel.dart';
import '../../channel/channel_method.dart';
import '../interface.dart';

/// 实现Native层页面路由
class MeteorNativeNavigator extends MeteorNavigatorInterface {
  final MeteorMethodChannel _pluginPlatform = MeteorMethodChannel();

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
    HzLog.t('MeteorNativeNavigator pushNamed:$routeName, arguments:$params');
    return await methodChannel.invokeMethod<T>(MeteorChannelMethod.pushNamedMethod, params);
  }

  @override
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    String untilRouteName, {
    Map<String, dynamic>? arguments,
  }) async {
    // HzLog.w('MeteorNativeNavigator pushNamed:$routeName, arguments:$params');
    HzLog.w('MeteorNativeNavigator No implemented method name pushNamedAndRemoveUntil in native ');
    return null;
  }

  @override
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    Map<String, dynamic>? arguments,
  }) async {
    HzLog.w('MeteorNativeNavigator No implemented method name pushReplacementNamed in native ');
    return null;
  }

  @override
  Future<T?> pop<T extends Object?>([T? result]) async {
    HzLog.t('MeteorNativeNavigator pop');
    await methodChannel.invokeMethod(MeteorChannelMethod.popMethod, result);
    return null;
  }

  @override
  Future<T?> popToRoot<T extends Object?>() async {
    HzLog.i('MeteorNativeNavigator popToRoot');
    return await methodChannel.invokeMethod<T>(MeteorChannelMethod.popToRootMethod);
  }

  @override
  Future<T?> popUntil<T extends Object?>(String routeName) async {
    HzLog.w('MeteorNativeNavigator No implemented method name popUntil in native ');
    return null;
  }

  @override
  Future<T?> popUntilLastNative<T extends Object?>() async {
    HzLog.t('MeteorNativeNavigator popUntilLastNative');
    return await methodChannel.invokeMethod<T>(MeteorChannelMethod.popMethod);
  }

  @override
  Future<T?> dismiss<T extends Object?>([T? result]) async {
    HzLog.t('MeteorNativeNavigator dismiss');
    if (Platform.isIOS) {
      return await methodChannel.invokeMethod<T>(MeteorChannelMethod.dismissMethod);
    } else {
      return await methodChannel.invokeMethod<T>(MeteorChannelMethod.popMethod);
    }
  }
}
