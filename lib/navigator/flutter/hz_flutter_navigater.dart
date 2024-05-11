import 'package:flutter/material.dart';
import 'package:hz_router/core/hz_router_interface.dart';

/// 实现flutter层页面路由
class HzFlutterNavigator extends HzRouterInterface {
  static String rootRoute = '/';
  static GlobalKey<NavigatorState>? rootKey;

  static BuildContext get rootContext {
    if (rootKey?.currentContext == null) {
      throw Exception("Context is null, you need to sure HzNavigator did init");
    }
    return rootKey!.currentContext!;
  }

  HzFlutterNavigator({GlobalKey<NavigatorState>? naviKey});
  @override
  Future<T?> pop<T extends Object?>(BuildContext? context, {T? result}) async {
    debugPrint('pop currentContext:$context, rootContext:$rootContext');

    context ??= context;
    if (context != null && Navigator.canPop(context)) {
      Navigator.pop<T>(context, result);
    }
    return null;
  }

  @override
  Future<T?> popToRoot<T extends Object?>(BuildContext? context) async {
    context ??= rootContext;
    debugPrint('popToRoot currentContext:$context, rootContext:$rootContext');
    if (context != null) {
      Navigator.popUntil(context, ModalRoute.withName(rootRoute));
    }
    return null;
  }

  @override
  Future<T?> popUntil<T extends Object?>(BuildContext? context, {required String routeName}) async {
    debugPrint('popUntil currentContext:$context, rootContext:$rootContext');
    context ??= rootContext;
    if (context != null) {
      Navigator.popUntil(context, ModalRoute.withName(routeName));
    }
    return null;
  }

  @override
  Future<T?> pushNamed<T extends Object?>(BuildContext? context,
      {required String routeName,
      bool withNewEngine = false,
      Map<String, dynamic>? arguments}) async {
    debugPrint('pushNamed currentContext:$context, rootContext:$rootContext');
    context ??= rootContext;
    if (context != null) {
      return Navigator.pushNamed<T?>(context, routeName, arguments: arguments);
    }
    return null;
  }

  @override
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(BuildContext? context,
      {required String routeName, String? untilRouteName, Map<String, dynamic>? arguments}) async {
    debugPrint('pushNamedAndRemoveUntil currentContext:$context, rootContext:$rootContext');
    context ??= rootContext;
    if (context != null) {
      return await Navigator.of(context).pushNamedAndRemoveUntil<T>(
          routeName, ModalRoute.withName(untilRouteName ?? rootRoute),
          arguments: arguments);
    }
    return null;
  }

  @override
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(BuildContext? context,
      {required String routeName, Map<String, dynamic>? arguments}) async {
    debugPrint('pushReplacementNamed currentContext:$context, rootContext:$rootContext');
    context ??= rootContext;
    if (context != null) {
      return await Navigator.pushReplacementNamed<T, TO>(context, routeName, arguments: arguments);
    }
    return null;
  }

  @override
  Future<T?> popUntilLastNative<T extends Object?>(BuildContext? context) async {
    debugPrint('popUntilLastNative currentContext:$context, rootContext:$rootContext');
    debugPrint('This method need to be implemented by native');
    return null;
  }
}
