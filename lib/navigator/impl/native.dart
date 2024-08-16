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
    bool isOpaque = true,
    bool openNative = false,
    bool present = false,
    bool animated = true,
    Map<String, dynamic>? arguments,
  }) async {
    Map<String, dynamic> params = {};
    params["routeName"] = routeName;
    params["withNewEngine"] = withNewEngine;
    params["isOpaque"] = isOpaque;
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
    bool isOpaque = true,
    bool openNative = false,
    bool animated = true,
    Map<String, dynamic>? arguments,
  }) async {
    Map<String, dynamic> params = {};
    params["routeName"] = routeName;
    params["untilRouteName"] = untilRouteName;
    params["withNewEngine"] = withNewEngine;
    params["isOpaque"] = isOpaque;
    params["openNative"] = openNative;
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
    bool isOpaque = true,
    bool openNative = false,
    bool animated = true,
    Map<String, dynamic>? arguments,
  }) async {
    Map<String, dynamic> params = {};
    params["routeName"] = routeName;
    params["withNewEngine"] = withNewEngine;
    params["isOpaque"] = isOpaque;
    params["openNative"] = openNative;
    params["arguments"] = arguments;
    params["animated"] = animated;
    return await methodChannel.invokeMethod<T>(
        FMNavigatorMethod.pushReplacementNamedMethod, params);
  }

  @override
  Future<T?> pushNamedAndRemoveUntilRoot<T extends Object?>(
    String routeName, {
    bool withNewEngine = false,
    bool isOpaque = true,
    bool openNative = false,
    bool animated = true,
    Map<String, dynamic>? arguments,
  }) async {
    Map<String, dynamic> params = {};
    params["routeName"] = routeName;
    params["withNewEngine"] = withNewEngine;
    params["isOpaque"] = isOpaque;
    params["openNative"] = openNative;
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
  void popUntil<T extends Object?>(String routeName, {bool isFarthest = false}) async {
    await methodChannel.invokeMethod<T>(
      FMNavigatorMethod.popUntilMethod,
      {
        'routeName': routeName,
        'result': {'isFarthest': isFarthest}
      },
    );
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

  @override
  Future<bool> isRoot(String routeName) async {
    // debugPrint('Flutter开始调用：method:${FMNavigatorMethod.isRoot}');
    final ret = await methodChannel.invokeMethod<bool>(
      FMNavigatorMethod.isRoot,
      {
        'routeName': routeName,
      },
    );
    // debugPrint('Flutter结束调用：method:${FMNavigatorMethod.isRoot}');
    return ret ?? false;
  }

  @override
  Future<bool> routeExists(String routeName) async {
    // debugPrint('Flutter开始调用：method:${FMNavigatorMethod.routeExists}');
    final ret = await methodChannel.invokeMethod<bool>(
      FMNavigatorMethod.routeExists,
      {
        'routeName': routeName,
      },
    );
    // debugPrint('Flutter结束调用：method:${FMNavigatorMethod.routeExists}');
    return ret ?? false;
  }

  @override
  Future<List<String>> routeNameStack() async {
    List<String> list = [];
    // debugPrint('Flutter开始调用：method:${FMNavigatorMethod.routeNameStack}');
    final ret = await methodChannel.invokeMethod(
      FMNavigatorMethod.routeNameStack,
    );
    if (ret is List) {
      for (var element in ret) {
        list.add(element.toString());
      }
    }
    // debugPrint('Flutter结束调用：method:${FMNavigatorMethod.routeNameStack}');
    return list;
  }

  @override
  Future<String?> topRouteName() async {
    // debugPrint('Flutter开始调用：method:${FMNavigatorMethod.topRouteName}');

    final ret = await methodChannel.invokeMethod<String>(
      FMNavigatorMethod.topRouteName,
    );
    // debugPrint('Flutter结束调用：method:${FMNavigatorMethod.topRouteName}');
    return ret;
  }

  @override
  Future<String?> rootRouteName() async {
    // debugPrint('Flutter开始调用：method:${FMNavigatorMethod.rootRouteName}');
    final ret = await methodChannel.invokeMethod<String>(
      FMNavigatorMethod.rootRouteName,
    );
    // debugPrint('Flutter结束调用：method:${FMNavigatorMethod.rootRouteName}');
    return ret;
  }

  Future<bool> topRouteIsNative() async {
    // debugPrint('Flutter开始调用：method:${FMNavigatorMethod.topRouteIsNative}');
    final ret = await methodChannel.invokeMethod<bool>(
      FMNavigatorMethod.topRouteIsNative,
    );
    // debugPrint('Flutter结束调用：method:${FMNavigatorMethod.topRouteIsNative}');
    return ret ?? false;
  }
}
