/*
* 封装系统的路由
* */

import 'package:flutter_meteor/navigator/page_type.dart';

/// 路由接口
abstract class MeteorNavigatorApi {
  /// push 到一个已经存在路由表的页面
  ///
  /// @param routeName 要跳转的页面
  /// @param pageType  PageType页面类型，默认PageType.flutter
  /// @param isOpaque 是否不透明 默认-true 不透明
  /// @param animated 是否开启动画，默认开启
  /// @param present iOS特有参数，默认false，当present = true时通过iOS的present方法打开新页面
  /// @return T  泛型，用于指定返回类型
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    PageType pageType = PageType.flutter,
    bool isOpaque = true,
    bool animated = true,
    bool present = false,
    Map<String, dynamic>? arguments,
  });

  /// push 到指定页面并替换当前页面
  ///
  /// @param routeName 要跳转的页面
  /// @param pageType  PageType页面类型，默认PageType.flutter
  /// @param isOpaque 是否不透明 默认-true 不透明
  /// @param animated 是否开启动画，默认开启
  /// @return T  泛型，用于指定返回类型
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    PageType pageType = PageType.flutter,
    bool isOpaque = true,
    bool animated = true,
    Map<String, dynamic>? arguments,
  });

  /// push 到指定页面，同时会清除从页面untilRouteName页面到指定routeName链路上的所有页面
  ///
  /// @param routeName 要跳转的页面
  /// @param pageType  PageType页面类型，默认PageType.flutter
  /// @param isOpaque 是否不透明 默认-true 不透明
  /// @param animated 是否开启动画，默认开启
  /// @param untilRouteName 移除截止页面，如果untilRouteName不存在会直接push
  /// @return T  泛型，用于指定返回类型
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String routeName,
    String untilRouteName, {
    PageType pageType = PageType.flutter,
    bool isOpaque = true,
    bool animated = true,
    Map<String, dynamic>? arguments,
  });

  /// push 到指定页面，同时会清除从页面untilRouteName页面到指定routeName链路上的所有页面
  ///
  /// @param routeName 要跳转的页面，
  /// @return T  泛型，用于指定返回类型
  Future<T?> pushNamedAndRemoveUntilRoot<T extends Object?>(
    String routeName, {
    PageType pageType = PageType.flutter,
    bool isOpaque = true,
    bool animated = true,
    Map<String, dynamic>? arguments,
  });

  /// pop到上一个页面
  ///
  /// @param result 接受回调，T是个泛型，可以指定要返回的数据类型
  Future<void> pop<T extends Object?>([T? result]);

  /// pop 到指定页面并替换当前页面
  ///
  /// @param routeName 要pod到的页面，如果对应routeName的路由不存在会pop到上一个页面
  /// @param isFarthest 是否pop到最远端的routeName，默认isFarthest = false表示最近的，isFarthest = true表示最远的
  Future<void> popUntil(String routeName, {bool isFarthest = false});

  /// pop 到最近的一个原生页面
  ///
  /// @param routeName 要pod到的页面
  Future<void> popUntilLastNative<T extends Object?>();

  /// pop 到根页面
  Future<void> popToRoot();

  /// 当前路由名栈
  Future<List<String>> routeNameStack();

  /// 最上层路由名称
  Future<String?> topRouteName();

  /// 根路由名称
  Future<String?> rootRouteName();

  /// 判断路由routeName是否存在
  Future<bool> routeExists(String routeName);

  /// 判断路由routeName是否为根路由
  Future<bool> isRoot(String routeName);
}
