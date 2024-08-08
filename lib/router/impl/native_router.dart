import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meteor/router/impl/flutter_router.dart';
import 'package:flutter_meteor/router/router_api.dart';

class FMRouterChannelMethod {
  static const String routeExists = 'routeExists';
  static const String isRoot = 'isRoot';
  static const String rootRouteName = 'rootRouteName';
  static const String topRouteName = 'topRouteName';
  static const String routeNameStack = 'routeNameStack';
  static const String topRouteIsNative = 'topRouteIsNative';
}

class FMNativeRouter implements MeteorRouterApi {
  /// route stack

  FMNativeRouter() {
    _setupMethodHandler();
  }

  final FMFlutterRouter _flutterRouter = FMFlutterRouter();
  static MethodChannel methodChannel = const MethodChannel('itbox.meteor.routerChannel');

  @override
  Future<bool> isRoot(String routeName) async {
    debugPrint('Flutter开始调用：method:${FMRouterChannelMethod.isRoot}');
    final ret = await methodChannel.invokeMethod<bool>(
      FMRouterChannelMethod.isRoot,
      {
        'routeName': routeName,
      },
    );
    debugPrint('Flutter结束调用：method:${FMRouterChannelMethod.isRoot}');
    return ret ?? false;
  }

  @override
  Future<bool> routeExists(String routeName) async {
    debugPrint('Flutter开始调用：method:${FMRouterChannelMethod.routeExists}');
    final ret = await methodChannel.invokeMethod<bool>(
      FMRouterChannelMethod.routeExists,
      {
        'routeName': routeName,
      },
    );
    debugPrint('Flutter结束调用：method:${FMRouterChannelMethod.routeExists}');
    return ret ?? false;
  }

  @override
  Future<List<String>> routeNameStack() async {
    List<String> list = [];
    debugPrint('Flutter开始调用：method:${FMRouterChannelMethod.routeNameStack}');
    final ret = await methodChannel.invokeMethod(
      FMRouterChannelMethod.routeNameStack,
    );
    if (ret is List) {
      for (var element in ret) {
        list.add(element.toString());
      }
    }
    debugPrint('Flutter结束调用：method:${FMRouterChannelMethod.routeNameStack}');
    return list;
  }

  @override
  Future<String?> topRouteName() async {
    debugPrint('Flutter开始调用：method:${FMRouterChannelMethod.topRouteName}');

    final ret = await methodChannel.invokeMethod<String>(
      FMRouterChannelMethod.topRouteName,
    );
    debugPrint('Flutter结束调用：method:${FMRouterChannelMethod.topRouteName}');
    return ret;
  }

  @override
  Future<String?> rootRouteName() async {
    debugPrint('Flutter开始调用：method:${FMRouterChannelMethod.rootRouteName}');
    final ret = await methodChannel.invokeMethod<String>(
      FMRouterChannelMethod.rootRouteName,
    );
    debugPrint('Flutter结束调用：method:${FMRouterChannelMethod.rootRouteName}');
    return ret;
  }

  Future<bool> topRouteIsNative() async {
    debugPrint('Flutter开始调用：method:${FMRouterChannelMethod.topRouteIsNative}');
    final ret = await methodChannel.invokeMethod<bool>(
      FMRouterChannelMethod.topRouteIsNative,
    );
    debugPrint('Flutter结束调用：method:${FMRouterChannelMethod.topRouteIsNative}');
    return ret ?? false;
  }

  void _setupMethodHandler() {
    methodChannel.setMethodCallHandler(
      (call) async {
        Map<String, dynamic> arguments = <String, dynamic>{};
        if (call.arguments is Map) {
          Map res = call.arguments;
          res.forEach((key, value) {
            arguments[key.toString()] = value;
          });
        } else {
          arguments["arguments"] = call.arguments;
        }
        // debugPrint('收到来自原生端的调用：method:${call.method}, argument:${call.arguments}');
        if (call.method == FMRouterChannelMethod.routeExists) {
          String routeName = arguments['routeName'] ?? '';
          bool ret = await _flutterRouter.routeExists(routeName);
          return ret;
        } else if (call.method == FMRouterChannelMethod.isRoot) {
          String routeName = arguments['routeName'] ?? '';
          bool ret = await _flutterRouter.isRoot(routeName);
          return ret;
        } else if (call.method == FMRouterChannelMethod.rootRouteName) {
          String? ret = await _flutterRouter.rootRouteName();
          return ret;
        } else if (call.method == FMRouterChannelMethod.topRouteName) {
          String? ret = await _flutterRouter.topRouteName();
          return ret;
        } else if (call.method == FMRouterChannelMethod.routeNameStack) {
          List<String> routeNameStack = await _flutterRouter.routeNameStack();
          return routeNameStack;
        } else {
          return null;
        }
      },
    );
  }
}
