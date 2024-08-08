import 'package:flutter/material.dart';
import 'package:flutter_meteor/flutter_meteor.dart';
import 'package:flutter_meteor/router/impl/flutter_router.dart';
import 'package:hz_tools/hz_tools.dart';

import 'impl/flutter.dart';
import 'impl/native.dart';

/// MeteorNavigator
class MeteorNavigator {
  static final MeteorNativeNavigator _nativeNavigator = MeteorNativeNavigator();
  static final MeteorFlutterNavigator _flutterNavigator = MeteorFlutterNavigator();

  static final FMFlutterRouter _flutterRouter = FMRouterManager.instance.flutterRouter;

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
    bool animated = true,
    Map<String, dynamic>? arguments,
  }) async {
    if (withNewEngine || openNative) {
      return await _nativeNavigator.pushNamed<T>(
        routeName,
        withNewEngine: withNewEngine,
        newEngineOpaque: newEngineOpaque,
        openNative: openNative,
        present: present,
        animated: animated,
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
    bool withNewEngine = false,
    bool newEngineOpaque = true,
    bool openNative = false,
    bool present = false,
    bool animated = true,
    Map<String, dynamic>? arguments,
  }) async {
    /// 当前引擎路由栈大于一个页面的时候直接在flutter端替换
    final routeStack = await _flutterRouter.routeNameStack();
    if (routeStack.length > 1 && !openNative && !withNewEngine) {
      return await _flutterNavigator.pushReplacementNamed<T, TO>(
        routeName,
        arguments: arguments,
      );
    } else {
      /// 当前引擎路由栈只有一个页面时调原生方法
      return await _nativeNavigator.pushReplacementNamed<T, TO>(
        routeName,
        withNewEngine: withNewEngine,
        newEngineOpaque: newEngineOpaque,
        openNative: openNative,
        present: present,
        animated: animated,
        arguments: arguments,
      );
    }
  }

  /// push 到指定页面，同时会清除从页面pushNamedAndRemoveUntil页面到指定routeName链路上的所有页面
  ///
  /// @parma routeName 要跳转的页面，
  /// @parma untilRouteName 移除截止页面
  /// @return T  泛型，用于指定返回类型
  static Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String routeName,
    String untilRouteName, {
    bool withNewEngine = false,
    bool newEngineOpaque = true,
    bool openNative = false,
    bool present = false,
    bool animated = true,
    Map<String, dynamic>? arguments,
  }) async {
    if (await _flutterRouter.routeExists(untilRouteName) && !openNative && !withNewEngine) {
      return await _flutterNavigator.pushNamedAndRemoveUntil<T>(
        routeName,
        untilRouteName,
        arguments: arguments,
      );
    } else {
      return await _nativeNavigator.pushNamedAndRemoveUntil<T>(
        routeName,
        untilRouteName,
        withNewEngine: withNewEngine,
        newEngineOpaque: newEngineOpaque,
        openNative: openNative,
        present: present,
        animated: animated,
        arguments: arguments,
      );
    }
  }

  /// push 到指定页面，同时会清除从页面跟页面到指定routeName链路上的所有页面
  ///
  /// @parma routeName 要跳转的页面，
  /// @return T  泛型，用于指定返回类型
  static Future<T?> pushNamedAndRemoveUntilRoot<T extends Object?>(
    String routeName, {
    bool withNewEngine = false,
    bool newEngineOpaque = true,
    bool openNative = false,
    bool present = false,
    bool animated = true,
    Map<String, dynamic>? arguments,
  }) async {
    return await _nativeNavigator.pushNamedAndRemoveUntilRoot<T>(
      routeName,
      withNewEngine: withNewEngine,
      newEngineOpaque: newEngineOpaque,
      openNative: openNative,
      present: present,
      animated: animated,
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
      _nativeNavigator.pop(result);
    }
  }

  /// dismiss当前页面，针对原生模态出来的页面
  ///
  /// @parma result 接受回调，T是个泛型，可以指定要返回的数据类型
  static void dismiss<T extends Object?>() async {
    _nativeNavigator.dismiss();
  }

  static void popUntilLastNative<T extends Object?>() async {
    _nativeNavigator.pop();
  }

  /// pop 到指定页面并替换当前页面
  ///
  /// @parma routeName 要pod到的页面
  static void popUntil(String routeName) async {
    _nativeNavigator.popUntil(routeName);
  }

  /// pop 到根页面
  static void popToRoot() async {
    _nativeNavigator.popToRoot();
  }
}
