import 'package:flutter/material.dart';

import '../interface.dart';


/// 实现flutter层页面路由
class MeteorFlutterNavigator extends MeteorNavigatorInterface {
  // static String rootRoute = '/';
  static GlobalKey<NavigatorState>? rootKey;

  static BuildContext get rootContext {
    if (rootKey?.currentContext == null) {
      throw Exception("Context is null, you need to sure MeteorNavigator did init");
    }
    return rootKey!.currentContext!;
  }

  @override
  Future<T?> pop<T extends Object?>([T? result]) async {
    debugPrint('pop rootContext:$rootContext');
    if (Navigator.canPop(rootContext)) {
      Navigator.pop<T>(rootContext, result);
    }
    return null;
  }

  @override
  Future<T?> popToRoot<T extends Object?>() async {
    return null;
  }

  @override
  Future<T?> popUntil<T extends Object?>(String routeName) async {
    debugPrint('popUntil rootContext:$rootContext');
    Navigator.popUntil(rootContext, ModalRoute.withName(routeName));
    return null;
  }

  void popToFirstRoute() {
    debugPrint('popToFirstRoute rootContext:$rootContext');
    Navigator.popUntil(rootContext, (route) => route.isFirst);
  }

  @override
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    bool withNewEngine = false,
    bool newEngineOpaque = true,
    bool openNative = false,
    Map<String, dynamic>? arguments,
  }) async {
    debugPrint('pushNamed rootContext:$rootContext');
    return Navigator.pushNamed<T?>(rootContext, routeName, arguments: arguments);
  }

  @override
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    String untilRouteName, {
    Map<String, dynamic>? arguments,
  }) async {
    debugPrint('pushNamedAndRemoveUntil rootContext:$rootContext');
    return Navigator.of(rootContext).pushNamedAndRemoveUntil<T>(
      newRouteName,
      ModalRoute.withName(untilRouteName),
      arguments: arguments,
    );
  }

  @override
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(String routeName,
      {Map<String, dynamic>? arguments}) async {
    debugPrint('pushReplacementNamed rootContext:$rootContext');
    return await Navigator.pushReplacementNamed<T, TO>(
      rootContext,
      routeName,
      arguments: arguments,
    );
  }

  @override
  Future<T?> popUntilLastNative<T extends Object?>() async {
    debugPrint('popUntilLastNative');
    debugPrint('This method need to be implemented by native');
    return null;
  }

  @override
  Future<T?> dismiss<T extends Object?>([T? result]) async {
    return null;
  }
}
