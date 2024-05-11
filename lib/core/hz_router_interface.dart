/*
* 封装系统的路由
* */

/// 路由接口
abstract class HzRouterInterface {
  /// push 到一个已经存在路由表的页面
  ///
  /// @parma routeName 要跳转的页面，
  /// @return T  泛型，用于指定返回类型
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    bool withNewEngine = false,
    Map<String, dynamic>? arguments,
  });

  /// push 到指定页面并替换当前页面
  ///
  /// @parma routeName 要跳转的页面，
  /// @return T  泛型，用于指定返回类型
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    Map<String, dynamic>? arguments,
  });

  /// push 到指定页面，同时会清除从页面untilRouteName页面到指定routeName链路上的所有页面
  ///
  /// @parma routeName 要跳转的页面，
  /// @parma untilRouteName 移除截止页面，默认跟试图'/'，
  /// @return T  泛型，用于指定返回类型
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    String untilRouteName, {
    Map<String, dynamic>? arguments,
  });

  /// pop到上一个页面
  ///
  /// @parma result 接受回调，T是个泛型，可以指定要返回的数据类型
  Future<T?> pop<T extends Object?>([T? result]);

  /// pop 到指定页面并替换当前页面
  ///
  /// @parma routeName 要pod到的页面
  Future<T?> popUntil<T extends Object?>(String routeName);

  /// pop 到最近的一个原生页面
  ///
  /// @parma routeName 要pod到的页面
  Future<T?> popUntilLastNative<T extends Object?>();

  /// pop 到根页面
  Future<T?> popToRoot<T extends Object?>();
}
