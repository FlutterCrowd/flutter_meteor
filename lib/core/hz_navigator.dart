import 'package:flutter/material.dart';
import 'package:hz_router/core/hz_router_manager.dart';

/*
* 封装系统的路由
* */

/// 路由封装
class HzNavigator {
  static String root = '/';
  static Route<dynamic>? routePage;
  static GlobalKey<NavigatorState>? naviKey;

  /// push 到一个已经存在路由表的页面
  ///
  /// @parma routeName 要跳转的页面，
  /// @return T  泛型，用于指定返回类型
  static Future<T?> pushNamed<T extends Object?>(
    BuildContext? context, {
    required String routeName,
    Map<String, dynamic>? arguments,
  }) async {
    context ??= naviKey?.currentContext;
    if (context != null) {
      return Navigator.pushNamed(context, routeName, arguments: arguments);
    }
    return null;
  }

  /// push 到指定页面并替换当前页面
  ///
  /// @parma routeName 要跳转的页面，
  /// @return T  泛型，用于指定返回类型
  static Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
      BuildContext? context,
      {required String routeName,
      Map<String, dynamic>? arguments}) async {
    context ??= naviKey?.currentContext;
    if (context != null) {
      return Navigator.pushReplacementNamed<T, TO>(context, routeName, arguments: arguments);
    }
    return null;
  }

  /// push 到指定页面，同时会清除从页面untilRouteName页面到指定routeName链路上的所有页面
  ///
  /// @parma routeName 要跳转的页面，
  /// @parma untilRouteName 移除截止页面，默认跟试图'/'，
  /// @return T  泛型，用于指定返回类型
  static Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    BuildContext? context, {
    required String routeName,
    String? untilRouteName,
    Map<String, dynamic>? arguments,
  }) async {
    context ??= naviKey?.currentContext;
    if (context != null) {
      return Navigator.of(context).pushNamedAndRemoveUntil<T>(
          routeName, ModalRoute.withName(untilRouteName ?? root),
          arguments: arguments);
    }
    return null;
  }

  /// pop到上一个页面
  ///
  /// @parma result 接受回调，T是个泛型，可以指定要返回的数据类型
  static Future<void> pop<T extends Object?>(BuildContext? context, {T? result}) async {
    context ??= naviKey?.currentContext;
    if (context != null && Navigator.canPop(context)) {
      return Navigator.pop<T>(context, result);
    }
  }

  /// pop 到指定页面并替换当前页面
  ///
  /// @parma routeName 要pod到的页面
  static Future<void> popUntil(BuildContext? context, {required String routeName}) async {
    context ??= naviKey?.currentContext;
    if (context != null) {
      return Navigator.popUntil(context, ModalRoute.withName(routeName));
    }
  }

  /// pop 到根页面
  static Future<void> popToRoot(BuildContext? context) async {
    context ??= naviKey?.currentContext;
    if (context != null) {
      Navigator.popUntil(context, ModalRoute.withName(root));
    }
  }

  // /// push 到一个新的page，不需要提前设置路由的页面
  // ///
  // /// @parma page 要跳转的页面
  // /// @return T  泛型，用于指定返回类型
  // static Future<T?> push<T extends Object?>(
  //   BuildContext context, {
  //   required Widget page,
  //   Map<String, dynamic>? arguments,
  // }) async {
  //   return Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => page),
  //   );
  // }

// 假设你有一个根页面的RouteSettings
  static Route<dynamic> getRootRoute() {
    // 这里应该返回你的根页面的Route对象
    // 例如，如果你使用NamedRoutes，那么你可以这样返回：
    return MaterialPageRoute(builder: HzRouterManager.routeInfo[root]!);
  }

  static bool isCurrentRouteRoot(BuildContext context) {
    // final rootRoute = getRootRoute();
    // final rootRouteSettings = rootRoute.settings;
    final RouteSettings? curRouteSetting = ModalRoute.of(context)?.settings;
    print(root);
    print(curRouteSetting?.name);
    // 遍历路由栈，查找与根页面相同的路由设置
    if (routePage?.settings != null && routePage?.settings == curRouteSetting) {
      // 如果找到了与根页面相同的路由设置，说明当前页面就是根页面
      return true;
    }
    // 如果没有找到与根页面相同的路由设置，说明当前页面不是根页面
    return false;
  }
}
