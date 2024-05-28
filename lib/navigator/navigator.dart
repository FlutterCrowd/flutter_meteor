import 'package:flutter/material.dart';

import 'impl/flutter.dart';
import 'impl/native.dart';

/// MeteorNavigator
class MeteorNavigator {
  // static Route<dynamic>? _rootRoute;
  // static set rootRoute(String value) {
  //   _rootRoute = _rootRoute;
  //   MeteorFlutterNavigator.rootRoute = value;
  // }

  // static Route<dynamic>? _rootPage;
  // static set rootPage(Route<dynamic> value) {
  //   _rootPage = value;
  // }

  static final MeteorNativeNavigator _nativeNavigator = MeteorNativeNavigator();
  static final MeteorFlutterNavigator _flutterNavigator = MeteorFlutterNavigator();

  static void init({
    required GlobalKey<NavigatorState> rootKey,
  }) {
    MeteorFlutterNavigator.rootKey = rootKey;
  }

  /// push 到一个已经存在路由表的页面
  ///
  /// @parma routeName 要跳转的页面，
  /// @return T  泛型，用于指定返回类型
  static Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    bool withNewEngine = false,
    bool newEngineOpaque = true,
    bool openNative = false,
    Map<String, dynamic>? arguments,
  }) async {
    debugPrint('Will push to page $routeName');
    if (withNewEngine || openNative) {
      return await _nativeNavigator.pushNamed<T>(
        routeName,
        withNewEngine: withNewEngine,
        newEngineOpaque: newEngineOpaque,
        openNative: openNative,
        arguments: arguments,
      );
    } else {
      return await _flutterNavigator.pushNamed<T>(
        routeName,
        arguments: arguments,
      );
    }
  }

  /// push 到指定页面并替换当前页面
  ///
  /// @parma routeName 要跳转的页面，
  /// @return T  泛型，用于指定返回类型
  static Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    Map<String, dynamic>? arguments,
  }) async {
    return await _flutterNavigator.pushReplacementNamed<T, TO>(routeName, arguments: arguments);
  }

  /// push 到指定页面，同时会清除从页面pushNamedAndRemoveUntil页面到指定routeName链路上的所有页面
  ///
  /// @parma newRouteName 要跳转的页面，
  /// @parma untilRouteName 移除截止页面
  /// @return T  泛型，用于指定返回类型
  static Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    String untilRouteName, {
    Map<String, dynamic>? arguments,
  }) async {
    return await _flutterNavigator.pushNamedAndRemoveUntil<T>(
      newRouteName,
      untilRouteName,
      arguments: arguments,
    );
  }

  /// push 到指定页面，同时会清除从页面跟页面到指定routeName链路上的所有页面
  ///
  /// @parma newRouteName 要跳转的页面，
  /// @return T  泛型，用于指定返回类型
  static Future<T?> pushNamedAndRemoveUntilRoot<T extends Object?>(
    String newRouteName, {
    Map<String, dynamic>? arguments,
  }) async {
    return await _flutterNavigator.pushNamedAndRemoveUntil<T>(
      newRouteName,
      '',
      arguments: arguments,
    );
  }

  /// pop到上一个页面
  ///
  /// @parma result 接受回调，T是个泛型，可以指定要返回的数据类型
  static void pop<T extends Object?>([T? result]) async {
    if (Navigator.canPop(MeteorFlutterNavigator.rootContext)) {
      _flutterNavigator.pop(result);
    } else {
      await _nativeNavigator.pop(result);
    }
  }

  /// dismiss当前页面，针对原生模态出来的页面
  ///
  /// @parma result 接受回调，T是个泛型，可以指定要返回的数据类型
  static void dismiss<T extends Object?>([T? result]) async {
    await _nativeNavigator.dismiss(result);
  }

  static Future<T?> popUntilLastNative<T extends Object?>() async {
    return await _nativeNavigator.pop();
  }

  /// pop 到指定页面并替换当前页面
  ///
  /// @parma routeName 要pod到的页面
  static void popUntil(String routeName) {
    _flutterNavigator.popUntil(routeName);
  }

  /// pop 到根页面
  static Future<void> popToRoot() async {
    _nativeNavigator.popToRoot();
  }

  static bool isCurrentRouteRoot() {
    return !Navigator.canPop(MeteorFlutterNavigator.rootContext);
  }
}
