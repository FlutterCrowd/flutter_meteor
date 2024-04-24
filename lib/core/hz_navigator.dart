import 'package:flutter/material.dart';

/*
* 封装系统的路由
* */

/// 路由封装
class HzNavigator {

  static String root = '/';

  /// push 到一个新的page，不需要提前设置路由的页面
  ///
  /// @parma page 要跳转的页面
  /// @return T  泛型，用于指定返回类型
  static Future<T?> push<T extends Object?>(
      BuildContext context, {
        required Widget page,
        Map<String, dynamic>? arguments, }) async {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  /// push 到一个已经存在路由表的页面
  ///
  /// @parma routeName 要跳转的页面，
  /// @return T  泛型，用于指定返回类型
  static Future<T?> pushNamed<T extends Object?>(
      BuildContext context, {
        required String routeName,
        Map<String, dynamic>? arguments, }) async {
    return Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  // /// push透明页面用的原生navigator
  // static Future<Object?>? pushOpaquePage<T extends Object?>(String name,
  //     {Map<String, dynamic>? arguments, required BuildContext context}) {
  //   HzRouteWidgetFactory? factory = RouterCenter.map[name];
  //   if (factory == null) {
  //     return null;
  //   }
  //
  //   return Navigator.of(context).push(PageRouteBuilder(
  //       opaque: false,
  //       pageBuilder: (context, animation, secondaryAnimation) {
  //         return factory(RouteSettings(arguments: arguments), null, context);
  //       }));
  // }

  /// push 到指定页面并替换当前页面
  ///
  /// @parma routeName 要跳转的页面，
  /// @return T  泛型，用于指定返回类型
  static Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
      BuildContext context,
      {required String routeName, Map<String, dynamic>? arguments}) async {
    return Navigator.pushReplacementNamed<T, TO>(context, routeName, arguments: arguments);
  }

  /// push 到指定页面，同时会清除从页面untilRouteName页面到指定routeName链路上的所有页面
  ///
  /// @parma routeName 要跳转的页面，
  /// @parma untilRouteName 移除截止页面，默认跟试图'/'，
  /// @return T  泛型，用于指定返回类型
  static Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
      BuildContext context,
      {
        required String routeName,
        String? untilRouteName,
        Map<String, dynamic>? arguments,
      }){
    return Navigator.of(context).pushNamedAndRemoveUntil<T>(routeName, ModalRoute.withName(untilRouteName ?? root), arguments: arguments);
  }

  /// pop到上一个页面
  ///
  /// @parma result 接受回调，T是个泛型，可以指定要返回的数据类型
  static Future<void> pop<T extends Object?>(BuildContext context, {T? result}) async {
    return Navigator.pop<T>(context, result);
  }

  /// pop 到指定页面并替换当前页面
  ///
  /// @parma routeName 要pod到的页面
  static Future<void> popUntil(BuildContext context, {required String routeName}) async {
    return Navigator.popUntil(context, ModalRoute.withName(routeName));
    // return Navigator.popUntil(context, (Route route) {
    //     return route.settings.name == routeName;
    // });
    // return BoostNavigator.instance.popUntil(route: route, uniqueId: uniqueId);
  }

  /// pop 到根页面
  static Future<void> popToRoot(BuildContext context) async {
    Navigator.popUntil(context, ModalRoute.withName(root));
    // return Navigator.popUntil(context, (Route route) {
    //   return route.settings.name == '/';
    // });
  }
}
