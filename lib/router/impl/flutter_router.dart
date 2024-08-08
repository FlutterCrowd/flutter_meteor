import 'package:flutter_meteor/router/observer.dart';
import 'package:flutter_meteor/router/router_api.dart';

class FMFlutterRouter implements MeteorRouterApi {
  static MeteorRouteObserver routerObserver = MeteorRouteObserver();
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
