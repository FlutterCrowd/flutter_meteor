import 'package:flutter/material.dart';
import 'package:flutter_meteor/navigator/observer.dart';
import 'package:flutter_meteor/navigator/page_type.dart';
import 'package:hz_tools/hz_tools.dart';

import '../navigator_api.dart';

/// 实现flutter层页面路由
class MeteorFlutterNavigator extends MeteorNavigatorApi {
  static GlobalKey<NavigatorState>? rootKey;
  static MeteorNavigatorObserver navigatorObserver = MeteorNavigatorObserver();

  static BuildContext get rootContext {
    if (rootKey?.currentContext == null) {
      throw Exception("Context is null, you need to sure MeteorNavigator did init");
    }
    return rootKey!.currentContext!;
  }

  @override
  Future<void> pop<T extends Object?>([T? result]) async {
    HzLog.t('MeteorFlutterNavigator pop rootContext:$rootContext');
    if (Navigator.canPop(rootContext)) {
      Navigator.pop<T>(rootContext, result);
    }
    return;
  }

  @override
  Future<void> popToRoot() async {
    HzLog.t('MeteorFlutterNavigator popToRoot');
    return Navigator.popUntil(
      rootContext,
      (route) => route.isFirst,
    );
  }

  @override
  Future<void> popUntil(String routeName, {bool isFarthest = false}) async {
    HzLog.t('MeteorFlutterNavigator popUntil routeName:$routeName');
    if (navigatorObserver.routeExists(routeName) && rootContext.mounted) {
      if (isFarthest) {
        for (Route<dynamic> route in navigatorObserver.routeStack) {
          if (route.settings.name == routeName) {
            Navigator.of(rootContext).popUntil((r) => r == route);
            break;
          }
        }
        return;
      } else {
        return Navigator.popUntil(
          rootContext,
          ModalRoute.withName(
            routeName,
          ),
        );
      }
    } else {
      HzLog.w('MeteorFlutterNavigator routeName:$routeName is not exist in navigator routeStack');
      return await pop();
    }
  }

  Future<void> popToFirstRoute() async {
    HzLog.t('MeteorFlutterNavigator popToFirstRoute');
    return Navigator.popUntil(
      rootContext,
      (route) => route.isFirst,
    );
  }

  @override
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    PageType pageType = PageType.flutter,
    bool isOpaque = true,
    bool animated = true,
    bool present = false,
    Map<String, dynamic>? arguments,
  }) async {
    HzLog.t(
        'MeteorFlutterNavigator pushNamed:$routeName, arguments:$arguments, pageType:$pageType');
    final result = await Navigator.pushNamed(
      rootContext,
      routeName,
      arguments: arguments,
    );
    if (result is! T?) {
      throw TypeError();
    }
    return result;
  }

  @override
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String routeName,
    String untilRouteName, {
    PageType pageType = PageType.flutter,
    bool isOpaque = true,
    bool animated = true,
    Map<String, dynamic>? arguments,
  }) async {
    HzLog.t(
        'MeteorFlutterNavigator pushReplacementNamed newRouteName:$routeName, untilRouteName:$untilRouteName, arguments:$arguments');
    dynamic result;
    if (navigatorObserver.routeExists(untilRouteName) && rootContext.mounted) {
      result = await Navigator.of(rootContext).pushNamedAndRemoveUntil(
        routeName,
        ModalRoute.withName(untilRouteName),
        arguments: arguments,
      );
    } else {
      HzLog.w(
          'MeteorFlutterNavigator untilRouteName:$untilRouteName is not exist in navigator routeStack');
      result = await Navigator.of(rootContext).pushNamed(
        routeName,
        arguments: arguments,
      );
    }
    if (result is! T?) {
      throw TypeError();
    }
    return result;
  }

  @override
  Future<T?> pushNamedAndRemoveUntilRoot<T extends Object?>(
    String routeName, {
    PageType pageType = PageType.flutter,
    bool isOpaque = true,
    bool animated = true,
    Map<String, dynamic>? arguments,
  }) async {
    HzLog.t(
        'MeteorFlutterNavigator pushNamedAndRemoveUntilRoot newRouteName:$routeName, arguments:$arguments');
    final result = await Navigator.of(rootContext).pushNamedAndRemoveUntil(
      routeName,
      (Route<dynamic> route) => route.isFirst,
      arguments: arguments,
    );
    if (result is! T?) {
      throw TypeError();
    }
    return result;
  }

  @override
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    PageType pageType = PageType.flutter,
    bool isOpaque = true,
    bool animated = true,
    Map<String, dynamic>? arguments,
  }) async {
    HzLog.t(
        'MeteorFlutterNavigator pushReplacementNamed routeName:$routeName, arguments:$arguments');
    final result = await Navigator.pushReplacementNamed(
      rootContext,
      routeName,
      arguments: arguments,
    );
    if (result is! T?) {
      throw TypeError();
    }
    return result;
  }

  @override
  Future<T?> popUntilLastNative<T extends Object?>() async {
    HzLog.w('This method:popUntilLastNative need to be implemented by native');
    return null;
  }

  @override
  Future<bool> isRoot(String routeName) async {
    return navigatorObserver.isRootRoute(routeName);
  }

  @override
  Future<bool> routeExists(String routeName) async {
    return navigatorObserver.routeExists(routeName);
  }

  @override
  Future<List<String>> routeNameStack() async {
    return navigatorObserver.routeNameStack;
  }

  @override
  Future<String?> rootRouteName() async {
    return navigatorObserver.rootRouteName;
  }

  @override
  Future<String?> topRouteName() async {
    return navigatorObserver.topRouteName;
  }
}
