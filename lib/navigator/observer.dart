import 'package:flutter/material.dart';

class MeteorRouteObserver extends NavigatorObserver {
  static final List<Route<dynamic>> _routeStack = [];

  static List<Route<dynamic>> get routeStack => List.unmodifiable(_routeStack);
  static List<String> get routeNameStack {
    List<String> names = <String>[];
    for (var element in routeStack) {
      names.add(element.settings.name ?? '');
    }
    return names;
  }

  static Route<dynamic>? get topRoute => _routeStack.isNotEmpty ? _routeStack.last : null;
  static Route<dynamic>? get rootRoute => _routeStack.isNotEmpty ? _routeStack.first : null;
  static String? get topRouteName => topRoute?.settings.name;
  static String? get rootRouteName => rootRoute?.settings.name;

  // static bool? get isRootRoute => _routeStack.isNotEmpty ? _routeStack.first : null;

  static bool isRootRoute(String routeName) {
    return routeName == rootRouteName;
  }

  static bool routeExists(String routeName) {
    return _routeStack.any(
      (route) => route.settings.name == routeName,
    );
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routeStack.add(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routeStack.remove(route);
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routeStack.remove(route);
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    final index = _routeStack.indexOf(oldRoute!);
    if (index != -1) {
      _routeStack[index] = newRoute!;
    }
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}
