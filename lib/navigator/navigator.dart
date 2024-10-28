import 'package:flutter/material.dart';
import 'package:flutter_meteor/navigator/page_type.dart';

import 'impl/flutter.dart';
import 'impl/native.dart';
import 'observer.dart';

export 'page_life_cycle.dart';
export 'page_type.dart';

/// MeteorNavigator
///
/// MeteorNavigator是Meteor框架的导航器，用于页面跳转，页面栈管理，页面返回等操作
///
/// MeteorNavigator支持两种引擎，Flutter引擎和Native引擎，Flutter引擎用于Flutter页面跳转，Native引擎用于原生页面跳转
///
/// MeteorNavigator支持两种页面类型，Flutter页面和Native页面，Flutter页面由Flutter引擎渲染，Native页面由Native引擎渲染
///
/// MeteorNavigator支持两种页面跳转方式，push和pushReplacement，push表示从当前页面跳转到指定页面
///

class MeteorNavigator {
  static final MeteorNativeNavigator _nativeNavigator = MeteorNativeNavigator();
  static final MeteorFlutterNavigator _flutterNavigator = MeteorFlutterNavigator();

  static MeteorNavigatorObserver navigatorObserver = MeteorFlutterNavigator.navigatorObserver;

  static void init({
    required GlobalKey<NavigatorState> rootKey,
  }) {
    MeteorFlutterNavigator.rootKey = rootKey;
  }

  /// push 到一个已经存在路由表的页面
  ///
  /// @param routeName 要跳转的页面
  /// @param pageType  PageType页面类型，默认PageType.flutter
  /// @param isOpaque 是否不透明 默认-true 不透明
  /// @param animated 是否开启动画，默认开启
  /// @param present iOS特有参数，默认false，当present = true时通过iOS的present方法打开新页面
  /// @return T  泛型，用于指定返回类型, 仅支持flutter -> flutter的场景
  static Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    PageType pageType = PageType.flutter,
    bool isOpaque = true,
    bool animated = true,
    bool present = false,
    Map<String, dynamic>? arguments,
  }) async {
    if (pageType != PageType.flutter) {
      return await _nativeNavigator.pushNamed<T>(
        routeName,
        pageType: pageType,
        isOpaque: isOpaque,
        animated: animated,
        present: present,
        arguments: arguments,
      );
    } else {
      return await _flutterNavigator.pushNamed<T>(
        routeName,
        isOpaque: isOpaque,
        animated: animated,
        arguments: arguments,
      );
    }
  }

  /// push 到指定页面并替换当前页面
  ///
  /// @param routeName 要跳转的页面
  /// @param pageType  PageType页面类型，默认PageType.flutter
  /// @param isOpaque 是否不透明 默认-true 不透明
  /// @param animated 是否开启动画，默认开启
  /// @return T  泛型，用于指定返回类型, 仅支持flutter -> flutter的场景
  static Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    PageType pageType = PageType.flutter,
    bool isOpaque = true,
    bool animated = true,
    Map<String, dynamic>? arguments,
  }) async {
    /// 当前引擎路由栈大于一个页面的时候直接在flutter端替换
    final routeStack = navigatorObserver.routeNameStack;
    if (routeStack.isNotEmpty && pageType == PageType.flutter) {
      return await _flutterNavigator.pushReplacementNamed<T, TO>(
        routeName,
        isOpaque: isOpaque,
        animated: animated,
        arguments: arguments,
      );
    } else {
      /// 当前引擎路由栈只有一个页面时调原生方法
      return await _nativeNavigator.pushReplacementNamed<T, TO>(
        routeName,
        pageType: pageType,
        isOpaque: isOpaque,
        animated: animated,
        arguments: arguments,
      );
    }
  }

  /// push 到指定页面，同时会清除从页面pushNamedAndRemoveUntil页面到指定routeName链路上的所有页面
  ///
  /// @param routeName 要跳转的页面
  /// @param pageType  PageType页面类型，默认PageType.flutter
  /// @param isOpaque 是否不透明 默认-true 不透明
  /// @param animated 是否开启动画，默认开启
  /// @parma untilRouteName 移除截止页面
  /// @return T  泛型，用于指定返回类型, 仅支持flutter -> flutter的场景
  static Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String routeName,
    String untilRouteName, {
    PageType pageType = PageType.flutter,
    bool isOpaque = true,
    bool animated = true,
    Map<String, dynamic>? arguments,
  }) async {
    if (navigatorObserver.routeExists(untilRouteName) && pageType == PageType.flutter) {
      return await _flutterNavigator.pushNamedAndRemoveUntil<T>(
        routeName,
        untilRouteName,
        isOpaque: isOpaque,
        animated: animated,
        arguments: arguments,
      );
    } else {
      return await _nativeNavigator.pushNamedAndRemoveUntil<T>(
        routeName,
        untilRouteName,
        pageType: pageType,
        isOpaque: isOpaque,
        animated: animated,
        arguments: arguments,
      );
    }
  }

  /// push 到指定页面，同时会清除从页面到根页面链路上的所有页面
  ///
  /// @param routeName 要跳转的页面
  /// @param pageType  PageType页面类型，默认PageType.flutter
  /// @param isOpaque 是否不透明 默认-true 不透明
  /// @param animated 是否开启动画，默认开启
  /// @return T  泛型，用于指定返回类型, 仅支持flutter -> flutter的场景
  static Future<T?> pushNamedAndRemoveUntilRoot<T extends Object?>(
    String routeName, {
    PageType pageType = PageType.flutter,
    bool isOpaque = true,
    bool animated = true,
    Map<String, dynamic>? arguments,
  }) async {
    return await _nativeNavigator.pushNamedAndRemoveUntilRoot<T>(
      routeName,
      pageType: pageType,
      isOpaque: isOpaque,
      animated: animated,
      arguments: arguments,
    );
  }

  /// pop到上一个页面
  ///
  /// @parma result 接受回调，T是个泛型，可以指定要返回的数据类型
  static Future<void> pop<T extends Object?>([T? result]) async {
    if (Navigator.canPop(MeteorFlutterNavigator.rootContext)) {
      return await _flutterNavigator.pop<T>(result);
    } else {
      return await _nativeNavigator.pop<T>(result);
    }
  }

  /// pop 到最近的一个原生页面
  ///
  /// @param result 返回结果
  static Future<void> popUntilLastNative<T extends Object?>([result]) async {
    return await _nativeNavigator.pop<T>(result);
  }

  /// pop 到指定页面并替换当前页面
  ///
  /// @param routeName 要pod到的页面，如果对应routeName的路由不存在会pop到上一个页面
  /// @param isFarthest 是否pop到最远端的routeName，默认isFarthest = false表示最近的，isFarthest = true表示最远的
  static Future<void> popUntil(String routeName, {bool isFarthest = false}) async {
    if (navigatorObserver.routeExists(routeName) && !isFarthest) {
      return await _flutterNavigator.popUntil(routeName, isFarthest: isFarthest);
    } else {
      return await _nativeNavigator.popUntil(routeName, isFarthest: isFarthest);
    }
  }

  /// pop 到根页面
  ///
  static Future<void> popToRoot() async {
    return await _nativeNavigator.popToRoot();
  }

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
    return await _nativeNavigator.rootRouteName();
  }

  /// 判断路由routeName是否存在
  static Future<bool> routeExists(String routeName) async {
    bool exists = navigatorObserver.routeExists(routeName);
    if (exists) {
      return exists;
    }
    return await _nativeNavigator.routeExists(routeName);
  }

  /// 判断路由顶层是否为原生
  static Future<bool> topRouteIsNative() async {
    return await _nativeNavigator.topRouteIsNative();
  }

  /// 判断路由routeName是否为根路由
  static Future<bool> isRoot(String routeName) async {
    String? rootName = await rootRouteName();
    return rootName != null && rootName == routeName;
  }

  /// 判断当前路由根路由
  static Future<bool> isCurrentRoot() async {
    String? top = await topRouteName();
    if (top == null) {
      return false;
    }
    return await _nativeNavigator.isRoot(top);
  }
}
