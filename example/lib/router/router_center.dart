import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hz_router_plugin_example/home/home_router.dart';
import 'package:hz_router_plugin_example/mine/mine_router.dart';
import 'package:hz_router_plugin_example/other/other_router.dart';
import 'package:hz_router_plugin_example/router/common.dart';
import 'package:hz_router_plugin_example/router/router_manager.dart';

import '../navigator/multi_engine_router.dart';

class AppRouterCenter extends RouteRegistry
    with HomeRouter, MineRouter, MultiEngineRouter, OtherRouter {
  static final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
  static RouteWidgetBuilder? notFoundHandler;

  AppRouterCenter._();

  static final AppRouterCenter _instance = AppRouterCenter._();

  static void setup() {
    _instance.install();
    debugPrint('RouterCenter Install routes:${RouterManager.routes}');
  }

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    return RouterManager.generateRoute(settings);
  }
}
