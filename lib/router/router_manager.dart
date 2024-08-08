import 'package:flutter_meteor/router/impl/flutter_router.dart';
import 'package:flutter_meteor/router/observer.dart';

import 'impl/native_router.dart';

class FMRouterManager {
  /// flutter路由观察者，用于记录当前路由变化

  final MeteorRouteObserver routerObserver = FMFlutterRouter.routerObserver;

  final FMNativeRouter nativeRouter = FMNativeRouter();

  final FMFlutterRouter flutterRouter = FMFlutterRouter();

  // 私有的构造函数，确保无法从外部实例化
  FMRouterManager._privateConstructor();

  // 单例的实例
  static final FMRouterManager _instance = FMRouterManager._privateConstructor();

  // 提供一个全局访问点
  static FMRouterManager get instance => _instance;

  /// 当前路由名栈
  static Future<List<String>> routeNameStack() async {
    return await instance.nativeRouter.routeNameStack();
  }

  /// 最上层路由名称
  static Future<String?> topRouteName() async {
    return await instance.nativeRouter.topRouteName();
  }

  /// 根路由名称
  static Future<String?> rootRouteName() async {
    return await instance.nativeRouter.rootRouteName();
  }

  /// 判断路由routeName是否存在
  static Future<bool> routeExists(String routeName) async {
    bool exists = instance.routerObserver.routeExists(routeName);
    if (exists) {
      return exists;
    }
    return await instance.nativeRouter.routeExists(routeName);
  }

  /// 判断路由顶层是否为原生
  static Future<bool> topRouteIsNative() async {
    return await instance.nativeRouter.topRouteIsNative();
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
    return await instance.nativeRouter.isRoot(top);
  }
}
