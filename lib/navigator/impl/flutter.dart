import 'package:flutter/material.dart';
import 'package:flutter_meteor/navigator/observer.dart';
import 'package:hz_tools/hz_tools.dart';

import '../navigator_api.dart';

/// 实现flutter层页面路由
class MeteorFlutterNavigator extends MeteorNavigatorApi {
  static GlobalKey<NavigatorState>? rootKey;
  static MeteorRouteObserver routerObserver = MeteorRouteObserver();

  static BuildContext get rootContext {
    if (rootKey?.currentContext == null) {
      throw Exception("Context is null, you need to sure MeteorNavigator did init");
    }
    return rootKey!.currentContext!;
  }

  @override
  Future<T?> pop<T extends Object?>([T? result]) async {
    HzLog.t('MeteorFlutterNavigator pop rootContext:$rootContext');
    if (Navigator.canPop(rootContext)) {
      Navigator.pop<T>(rootContext, result);
    }
    return null;
  }

  @override
  Future<T?> popToRoot<T extends Object?>() async {
    HzLog.w('This method:popToRoot need to be implemented by native');
    Navigator.popUntil(
      rootContext,
      (route) => route.isFirst,
    );
    return null;
  }

  @override
  Future<T?> popUntil<T extends Object?>(String routeName) async {
    HzLog.t('MeteorFlutterNavigator popUntil routeName:$routeName');
    if (routerObserver.routeExists(routeName) && rootContext.mounted) {
      Navigator.popUntil(
        rootContext,
        ModalRoute.withName(
          routeName,
        ),
      );
    } else {
      HzLog.w('MeteorFlutterNavigator routeName:$routeName is not exist in navigator routeStack');
      pop();
    }
    return null;
  }

  void popToFirstRoute() {
    HzLog.t('MeteorFlutterNavigator popToFirstRoute');
    Navigator.popUntil(
      rootContext,
      (route) => route.isFirst,
    );
  }

  @override
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    bool withNewEngine = false,
    bool isOpaque = true,
    bool openNative = false,
    bool present = false,
    bool animated = true,
    Map<String, dynamic>? arguments,
  }) async {
    HzLog.t(
        'MeteorFlutterNavigator pushNamed:$routeName, arguments:$arguments, withNewEngine:$withNewEngine, openNative:$openNative');
    return await Navigator.pushNamed<T?>(
      rootContext,
      routeName,
      arguments: arguments,
    );
  }

  @override
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String routeName,
    String untilRouteName, {
    bool withNewEngine = false,
    bool isOpaque = true,
    bool openNative = false,
    bool present = false,
    bool animated = true,
    Map<String, dynamic>? arguments,
  }) async {
    HzLog.t(
        'MeteorFlutterNavigator pushReplacementNamed newRouteName:$routeName, untilRouteName:$untilRouteName, arguments:$arguments');
    if (routerObserver.routeExists(untilRouteName) && rootContext.mounted) {
      return await Navigator.of(rootContext).pushNamedAndRemoveUntil<T>(
        routeName,
        ModalRoute.withName(untilRouteName),
        arguments: arguments,
      );
    } else {
      HzLog.w(
          'MeteorFlutterNavigator untilRouteName:$untilRouteName is not exist in navigator routeStack');
      return await Navigator.of(rootContext).pushNamed<T>(
        routeName,
        arguments: arguments,
      );
    }
  }

  @override
  Future<T?> pushNamedAndRemoveUntilRoot<T extends Object?>(
    String routeName, {
    bool withNewEngine = false,
    bool isOpaque = true,
    bool openNative = false,
    bool present = false,
    bool animated = true,
    Map<String, dynamic>? arguments,
  }) async {
    HzLog.t(
        'MeteorFlutterNavigator pushNamedAndRemoveUntilRoot newRouteName:$routeName, arguments:$arguments');
    return await Navigator.of(rootContext).pushNamedAndRemoveUntil<T>(
      routeName,
      (Route<dynamic> route) => route.isFirst,
      arguments: arguments,
    );
  }

  @override
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    bool withNewEngine = false,
    bool isOpaque = true,
    bool openNative = false,
    bool present = false,
    bool animated = true,
    Map<String, dynamic>? arguments,
  }) async {
    HzLog.t(
        'MeteorFlutterNavigator pushReplacementNamed routeName:$routeName, arguments:$arguments');
    return await Navigator.pushReplacementNamed<T, TO>(
      rootContext,
      routeName,
      arguments: arguments,
    );
  }

  @override
  Future<T?> popUntilLastNative<T extends Object?>() async {
    HzLog.w('This method:popUntilLastNative need to be implemented by native');
    return null;
  }

  @override
  Future<T?> dismiss<T extends Object?>() async {
    HzLog.w('This method:dismiss need to be implemented by native');
    return null;
  }

  @override
  Future<bool> isRoot(String routeName) async {
    return routerObserver.isRootRoute(routeName);
  }

  @override
  Future<bool> routeExists(String routeName) async {
    return routerObserver.routeExists(routeName);
  }

  @override
  Future<List<String>> routeNameStack() async {
    return routerObserver.routeNameStack;
  }

  @override
  Future<String?> rootRouteName() async {
    return routerObserver.rootRouteName;
  }

  @override
  Future<String?> topRouteName() async {
    return routerObserver.topRouteName;
  }
}
