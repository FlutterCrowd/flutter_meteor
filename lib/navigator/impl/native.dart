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
    return await methodChannel.invokeMethod<T>(MeteorChannelMethod.pushNamedMethod, params);
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
        MeteorChannelMethod.pushNamedAndRemoveUntilMethod, params);
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
        MeteorChannelMethod.pushReplacementNamedMethod, params);
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
    await methodChannel
        .invokeMethod<T>(MeteorChannelMethod.popUntilMethod, {'routeName': routeName});
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
        MeteorChannelMethod.pushReplacementNamedMethod, arguments);
  }

  @override
  Future<bool> isRoot(String routeName) async {
    final ret = await methodChannel.invokeMethod<bool>(
      MeteorChannelMethod.isRoot,
      {
        'routeName': routeName,
      },
    );
    return ret ?? false;
  }

  @override
  Future<String?> rootRouteName() async {
    final ret = await methodChannel.invokeMethod<String>(MeteorChannelMethod.rootRouteName);
    return ret;
  }

  @override
  Future<bool> routeExists(String routeName) async {
    final ret = await methodChannel.invokeMethod<bool>(
      MeteorChannelMethod.routeExists,
      {
        'routeName': routeName,
      },
    );
    return ret ?? false;
  }

  @override
  Future<List<String>> routeNameStack() async {
    List<String> list = [];
    final ret = await methodChannel.invokeMethod(MeteorChannelMethod.routeNameStack);
    if (ret is List) {
      for (var element in ret) {
        list.add(element.toString());
      }
    }
    return list;
  }

  @override
  Future<String?> topRouteName() async {
    final ret = await methodChannel.invokeMethod<String>(MeteorChannelMethod.topRouteName);
    return ret;
  }

  @override
  Future<bool> topRouteIsNative() async {
    final ret = await methodChannel.invokeMethod<bool>(MeteorChannelMethod.topRouteIsNative);
    return ret ?? false;
  }
}
