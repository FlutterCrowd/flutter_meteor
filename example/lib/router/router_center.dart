import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meteor/router/router.dart';
import 'package:hz_router_plugin_example/home/home_router.dart';
import 'package:hz_router_plugin_example/mine/mine_router.dart';
import 'package:hz_router_plugin_example/other/other_router.dart';
import 'package:hz_router_plugin_example/router/route_registry.dart';

import '../navigator/multi_engine_router.dart';
import '../other/undefined_route_page.dart';

class AppRouterCenter extends RouteRegistry
    with HomeRouter, MineRouter, MultiEngineRouter, OtherRouter {
  static final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
  static RouteWidgetBuilder? notFoundHandler;

  AppRouterCenter._();

  static final AppRouterCenter _instance = AppRouterCenter._();

  static void setup() {
    _instance.install();
    if (kDebugMode) {
      RouterManager.setUnknownRoute(
        (arguments) => const UndefinedRoutePage(),
      );
    }
    // debugPrint('RouterCenter Install routes:${RouterManager.routes}');
  }

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    return RouterManager.generateRoute(settings);
  }
}
