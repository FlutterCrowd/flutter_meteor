import 'package:flutter/material.dart';

class HzRouterManager {

  static final Map<String, WidgetBuilder> _routeInfo = {};
  static Map<String, WidgetBuilder> get routeInfo => _routeInfo;

  static void insertRouters(Map<String, WidgetBuilder> routers) {
    _routeInfo.addAll(routers);
  }

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final String? name = settings.name;
    final Widget Function(BuildContext)? pageRouteBuilder = routeInfo[name];
    if (pageRouteBuilder != null) {
      final Route<dynamic> route = MaterialPageRoute(
        builder: pageRouteBuilder,
        settings: settings,
      );
      return route;
    } else {
      return null;
    }
  }
}