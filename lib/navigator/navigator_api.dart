/*
* 封装系统的路由
* */

/// 路由接口
abstract class MeteorNavigatorApi {
  /// push 到一个已经存在路由表的页面
  ///
  /// @parma routeName 要跳转的页面，
  /// @parma withNewEngine 是否开启新引擎，当 withNewEngine = true时，通过原生通道开启新引擎打开flutter页面
  /// 默认withNewEngine = false，直接走flutter端内部路由push新页面
  /// @parma isOpaque 是否不透明 默认-true 不透明
  /// @parma openNative 是否打开原生
  /// @parma present iOS特有参数，默认false，当present = true时通过iOS的present方法打开新页面
  /// @parma animated 是否开启动画，默认开启
  /// @return T  泛型，用于指定返回类型
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    bool withNewEngine = false,
    bool isOpaque = true,
    bool openNative = false,
    bool present = false,
    bool animated = true,
    Map<String, dynamic>? arguments,
  });

  /// push 到指定页面并替换当前页面
  ///
  /// @parma routeName 要跳转的页面，
  /// @return T  泛型，用于指定返回类型
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    bool withNewEngine = false,
    bool isOpaque = true,
    bool openNative = false,
    bool animated = true,
    Map<String, dynamic>? arguments,
  });

  /// push 到指定页面，同时会清除从页面untilRouteName页面到指定routeName链路上的所有页面
  ///
  /// @parma routeName 要跳转的页面，
  /// @parma untilRouteName 移除截止页面，如果untilRouteName不存在会直接push
  /// @return T  泛型，用于指定返回类型
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String routeName,
    String untilRouteName, {
    bool withNewEngine = false,
    bool isOpaque = true,
    bool openNative = false,
    bool animated = true,
    Map<String, dynamic>? arguments,
  });

  /// push 到指定页面，同时会清除从页面untilRouteName页面到指定routeName链路上的所有页面
  ///
  /// @parma routeName 要跳转的页面，
  /// @return T  泛型，用于指定返回类型
  Future<T?> pushNamedAndRemoveUntilRoot<T extends Object?>(
    String routeName, {
    bool withNewEngine = false,
    bool isOpaque = true,
    bool openNative = false,
    bool animated = true,
    Map<String, dynamic>? arguments,
  });

  /// pop到上一个页面
  ///
  /// @parma result 接受回调，T是个泛型，可以指定要返回的数据类型
  void pop<T extends Object?>([T? result]);

  /// pop 到指定页面并替换当前页面
  ///
  /// @parma routeName 要pod到的页面，如果对应routeName的路由不存在会pop到上一个页面
  void popUntil<T extends Object?>(String routeName);

  /// pop 到最近的一个原生页面
  ///
  /// @parma routeName 要pod到的页面
  void popUntilLastNative<T extends Object?>();

  /// pop 到根页面
  void popToRoot<T extends Object?>();

  /// 返回原生模态出的视图
  void dismiss<T extends Object?>();

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
