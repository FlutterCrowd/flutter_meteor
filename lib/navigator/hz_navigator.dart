import 'package:flutter/material.dart';
import 'package:hz_router/core/hz_router_manager.dart';
import 'package:hz_router/navigator/native/hz_native_navigator.dart';

import 'flutter/hz_flutter_navigater.dart';

/*
* 封装系统的路由
* */

/// 路由封装
class HzNavigator {
  static Route<dynamic>? _rootRoute;
  static set rootRoute(String value) {
    _rootRoute = _rootRoute;
    HzFlutterNavigator.rootRoute = value;
  }

  static Route<dynamic>? _rootPage;
  static set rootPage(Route<dynamic> value) {
    _rootPage = value;
  }

  static final HzNativeNavigator _nativeNavigator = HzNativeNavigator();
  static final HzFlutterNavigator _flutterNavigator = HzFlutterNavigator();

  static void init({
    required GlobalKey<NavigatorState> rootKey,
  }) {
    HzFlutterNavigator.rootKey = rootKey;
  }

  /// push 到一个已经存在路由表的页面
  ///
  /// @parma routeName 要跳转的页面，
  /// @return T  泛型，用于指定返回类型
  static Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    bool withNewEngine = false,
    Map<String, dynamic>? arguments,
  }) async {
    debugPrint('Will push to page $routeName');
    if (withNewEngine || HzRouterManager.routeInfo[routeName] == null) {
      return await _nativeNavigator.pushNamed<T>(
        routeName,
        withNewEngine: withNewEngine,
        arguments: arguments,
      );
    } else {
      return await _flutterNavigator.pushNamed<T>(
        routeName,
        withNewEngine: withNewEngine,
        arguments: arguments,
      );
    }
  }

  /// push 到指定页面并替换当前页面
  ///
  /// @parma routeName 要跳转的页面，
  /// @return T  泛型，用于指定返回类型
  static Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(String routeName,
      {Map<String, dynamic>? arguments}) async {
    if (HzRouterManager.routeInfo[routeName] == null) {
      debugPrint('No invalid routeName:$routeName');
      return null;
    } else {
      return await _flutterNavigator.pushReplacementNamed<T, TO>(routeName, arguments: arguments);
    }
  }

  /// push 到指定页面，同时会清除从页面untilRouteName页面到指定routeName链路上的所有页面
  ///
  /// @parma newRouteName 要跳转的页面，
  /// @parma untilRouteName 移除截止页面，默认跟试图'/'，
  /// @return T  泛型，用于指定返回类型
  static Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    String untilRouteName, {
    Map<String, dynamic>? arguments,
  }) async {
    if (HzRouterManager.routeInfo[newRouteName] == null) {
      debugPrint('No invalid routeName:$newRouteName');
      return null;
    } else {
      return await _flutterNavigator.pushNamedAndRemoveUntil<T>(newRouteName, untilRouteName,
          arguments: arguments);
    }
  }

  /// pop到上一个页面
  ///
  /// @parma result 接受回调，T是个泛型，可以指定要返回的数据类型
  static void pop<T extends Object?>([T? result]) async {
    if (Navigator.canPop(HzFlutterNavigator.rootContext)) {
      _flutterNavigator.pop(result);
    } else {
      await _nativeNavigator.pop(result);
    }
  }

  static Future<T?> popUntilLastNative<T extends Object?>() async {
    return await _nativeNavigator.pop(null);
  }

  /// pop 到指定页面并替换当前页面
  ///
  /// @parma routeName 要pod到的页面
  static Future<void> popUntil(String routeName) async {
    if (HzRouterManager.routeInfo[routeName] == null) {
      debugPrint('No invalid routeName:$routeName');
      return;
      // return await _nativeNavigator.popUntil(context, routeName: routeName);
    } else {
      _flutterNavigator.popUntil(routeName);
    }
    return;
  }

  /// pop 到根页面
  static Future<void> popToRoot() async {
    _nativeNavigator.popToRoot();
  }

// 假设你有一个根页面的RouteSettings
  static Route<dynamic> getRootRoute() {
    // 这里应该返回你的根页面的Route对象
    // 例如，如果你使用NamedRoutes，那么你可以这样返回：
    return MaterialPageRoute(builder: HzRouterManager.routeInfo[_rootRoute]!);
  }

  static bool isCurrentRouteRoot(BuildContext context) {
    final RouteSettings? curRouteSetting = ModalRoute.of(context)?.settings;
    // 遍历路由栈，查找与根页面相同的路由设置
    if (_rootPage?.settings != null && _rootPage?.settings == curRouteSetting) {
      // 如果找到了与根页面相同的路由设置，说明当前页面就是根页面
      return true;
    }
    // 如果没有找到与根页面相同的路由设置，说明当前页面不是根页面
    return false;
  }
}
