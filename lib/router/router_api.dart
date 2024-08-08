/*
* 封装系统的路由
* */

/// 路由接口
abstract class MeteorRouterApi {
  //
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
