import 'package:flutter/material.dart';
import 'package:flutter_meteor/flutter_meteor.dart';
import 'package:hz_tools/hz_tools.dart';

import 'impl/flutter.dart';
import 'impl/native.dart';
import 'observer.dart';

/// MeteorNavigator
class MeteorNavigator {
  static final MeteorNativeNavigator _nativeNavigator = MeteorNativeNavigator();
  static final MeteorFlutterNavigator _flutterNavigator = MeteorFlutterNavigator();

  static void init({
    required GlobalKey<NavigatorState> rootKey,
  }) {
    HzLog.i('MeteorNavigator init with rootKey:$rootKey');
    MeteorFlutterNavigator.rootKey = rootKey;
  }

  /// push 到一个已经存在路由表的页面
  ///
  /// @parma routeName 要跳转的页面，
  /// @parma withNewEngine 是否开启新引擎，当 withNewEngine = true时，通过原生通道开启新引擎打开flutter页面
  /// 默认withNewEngine = false，直接走flutter端内部路由push新页面
  /// @parma newEngineOpaque 是否透明 默认-true 不透明
  /// @parma openNative 是否打开原生
  /// @parma present iOS特有参数，默认false，当present = true时通过iOS的present方法打开新页面
  /// @return T  泛型，用于指定返回类型
  static Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    bool withNewEngine = false,
    bool newEngineOpaque = true,
    bool openNative = false,
    bool present = false,
    Map<String, dynamic>? arguments,
  }) async {
    if (withNewEngine || openNative) {
      return await _nativeNavigator.pushNamed<T>(
        routeName,
        withNewEngine: withNewEngine,
        newEngineOpaque: newEngineOpaque,
        openNative: openNative,
        arguments: arguments,
        present: present,
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
    return await _flutterNavigator.pushNamedAndRemoveUntilRoot<T>(
      newRouteName,
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
  static Future<void> popUntil(String routeName) async{
    _nativeNavigator.popUntil(routeName);
  }

  /// pop 到根页面
  static Future<void> popToRoot() async {
    _nativeNavigator.popToRoot();
  }

  // /// flutter路由观察者，用于记录当前路由变化
  static final MeteorRouteObserver navigatorObserver = MeteorFlutterNavigator.routeObserver;

  /// 当前路由名栈
  static Future<List<String>> routeNameStack() async {
    return await _nativeNavigator.routeNameStack();
  }

  /// 最上层路由名称
  static Future<String?> topRouteName() async {
    return await _nativeNavigator.topRouteName();
  }

  /// 根路由名称
  static Future<String?> rootRouteName() async {
    if (MeteorEngine.isMain) {
      return navigatorObserver.rootRouteName;
    }
    return await _nativeNavigator.rootRouteName();
  }

  /// 判断路由routeName是否存在
  static Future<bool> routeExists(String routeName) async {
    return await _nativeNavigator.routeExists(routeName);
  }

  /// 判断路由顶层是否为原生
  static Future<bool> topRouteIsNative() async {
    return await _nativeNavigator.topRouteIsNative();
  }

  /// 判断路由routeName是否为根路由
  static Future<bool> isRoot(String routeName) async {
    return await _nativeNavigator.isRoot(routeName);
  }

  /// 判断当前路由根路由
  static Future<bool> isCurrentRoot() async {
    if (!MeteorEngine.isMain) {
      return false;
    }
    String? top = await topRouteName();
    if (top == null) {
      return false;
    }
    return await _nativeNavigator.isRoot(top);
  }
}
