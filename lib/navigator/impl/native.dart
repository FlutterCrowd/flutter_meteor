import 'dart:io';

import 'package:flutter/services.dart';
import 'package:hz_tools/hz_tools.dart';

import '../channel/channel.dart';
import '../channel/method.dart';
import '../navigator_api.dart';

/// 实现Native层页面路由
class MeteorNativeNavigator extends MeteorNavigatorApi {
  final MeteorMethodChannel _pluginPlatform = MeteorMethodChannel();

  MethodChannel get methodChannel => _pluginPlatform.methodChannel;

  @override
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    bool withNewEngine = false,
    bool newEngineOpaque = true,
    bool openNative = false,
    bool present = false,
    bool animated = true,
    Map<String, dynamic>? arguments,
  }) async {
    Map<String, dynamic> params = {};
    params["routeName"] = routeName;
    params["withNewEngine"] = withNewEngine;
    params["newEngineOpaque"] = newEngineOpaque;
    params["openNative"] = openNative;
    params["present"] = present;
    params["arguments"] = arguments;
    params["animated"] = animated;
    HzLog.t('MeteorNativeNavigator pushNamed:$routeName, arguments:$params');
    return await methodChannel.invokeMethod<T>(FMNavigatorMethod.pushNamedMethod, params);
  }

  @override
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String routeName,
    String untilRouteName, {
    bool withNewEngine = false,
    bool newEngineOpaque = true,
    bool openNative = false,
    bool present = false,
    bool animated = true,
    Map<String, dynamic>? arguments,
  }) async {
    Map<String, dynamic> params = {};
    params["routeName"] = routeName;
    params["untilRouteName"] = untilRouteName;
    params["withNewEngine"] = withNewEngine;
    params["newEngineOpaque"] = newEngineOpaque;
    params["openNative"] = openNative;
    params["present"] = present;
    params["arguments"] = arguments;
    params["animated"] = animated;
    // HzLog.w('MeteorNativeNavigator pushNamed:$routeName, arguments:$params');
    return await methodChannel.invokeMethod<T>(
        FMNavigatorMethod.pushNamedAndRemoveUntilMethod, params);
  }

  @override
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    bool withNewEngine = false,
    bool newEngineOpaque = true,
    bool openNative = false,
    bool present = false,
    bool animated = true,
    Map<String, dynamic>? arguments,
  }) async {
    Map<String, dynamic> params = {};
    params["routeName"] = routeName;
    params["withNewEngine"] = withNewEngine;
    params["newEngineOpaque"] = newEngineOpaque;
    params["openNative"] = openNative;
    params["present"] = present;
    params["arguments"] = arguments;
    params["animated"] = animated;
    return await methodChannel.invokeMethod<T>(
        FMNavigatorMethod.pushReplacementNamedMethod, params);
  }

  @override
  Future<T?> pushNamedAndRemoveUntilRoot<T extends Object?>(
    String routeName, {
    bool withNewEngine = false,
    bool newEngineOpaque = true,
    bool openNative = false,
    bool present = false,
    bool animated = true,
    Map<String, dynamic>? arguments,
  }) async {
    Map<String, dynamic> params = {};
    params["routeName"] = routeName;
    params["withNewEngine"] = withNewEngine;
    params["newEngineOpaque"] = newEngineOpaque;
    params["openNative"] = openNative;
    params["present"] = present;
    params["arguments"] = arguments;
    params["animated"] = animated;
    return await methodChannel.invokeMethod<T>(
        FMNavigatorMethod.pushNamedAndRemoveUntilRootMethod, params);
  }

  @override
  void pop<T extends Object?>([T? result]) async {
    HzLog.t('MeteorNativeNavigator pop');
    await methodChannel.invokeMethod(FMNavigatorMethod.popMethod, result);
    return null;
  }

  @override
  void popToRoot<T extends Object?>([T? result]) async {
    HzLog.i('MeteorNativeNavigator popToRoot');
    await methodChannel.invokeMethod<T>(FMNavigatorMethod.popToRootMethod);
  }

  @override
  void popUntil<T extends Object?>(String routeName, [T? result]) async {
    await methodChannel.invokeMethod<T>(FMNavigatorMethod.popUntilMethod, {'routeName': routeName});
  }

  @override
  void popUntilLastNative<T extends Object?>() async {
    HzLog.t('MeteorNativeNavigator popUntilLastNative');
    await methodChannel.invokeMethod<T>(FMNavigatorMethod.popMethod);
  }

  @override
  void dismiss<T extends Object?>() async {
    HzLog.t('MeteorNativeNavigator dismiss');
    if (Platform.isIOS) {
      await methodChannel.invokeMethod<T>(FMNavigatorMethod.dismissMethod);
    } else {
      await methodChannel.invokeMethod<T>(FMNavigatorMethod.popMethod);
    }
  }
}
