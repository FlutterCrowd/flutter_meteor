import 'package:hz_router_plugin_example/router/route_options.dart';

class MixinRouteContainer {
  final Map<String, RouteOptions> _routes = {};
  Map<String, RouteOptions> get mixinRoutes => _routes;
  void addRoutes(Map<String, RouteOptions> routes) {
    _routes.addAll(routes);
  }

  /// 不透明路由
  void addRoute(String name, RouteWidgetBuilder builder) {
    RouteOptions<MaterialPageRouteOptions> options =
        RouteOptions(builder, MaterialPageRouteOptions());
    _routes.putIfAbsent(name, () => options);
  }

  /// 透明路由
  void addTransparentRoute(String name, RouteWidgetBuilder builder) {
    PageRouteOptions pageRouteOptions = PageRouteOptions(
      opaque: false,
    );
    RouteOptions<PageRouteOptions> options =
        RouteOptions<PageRouteOptions>(builder, pageRouteOptions);
    _routes.putIfAbsent(name, () => options);
  }

  /// 自定义不透明Material路由
  void addCustomMaterialPageRoute(String name, RouteWidgetBuilder builder,
      {MaterialPageRouteOptions? pageRouteOptions}) {
    RouteOptions<MaterialPageRouteOptions> options = RouteOptions<MaterialPageRouteOptions>(
        builder, pageRouteOptions ?? MaterialPageRouteOptions());
    _routes.putIfAbsent(name, () => options);
  }

  /// 自定义路由
  void addCustomPageRoute(String name, RouteWidgetBuilder builder,
      {PageRouteOptions? pageRouteOptions}) {
    RouteOptions<PageRouteOptions> options =
        RouteOptions<PageRouteOptions>(builder, pageRouteOptions ?? PageRouteOptions());
    _routes.putIfAbsent(name, () => options);
  }

  /// 自定义Dialog路由
  void addDialogPageRoute(String name, RouteWidgetBuilder builder,
      {DialogRouteOptions? pageRouteOptions}) {
    RouteOptions<DialogRouteOptions> options =
        RouteOptions<DialogRouteOptions>(builder, pageRouteOptions ?? DialogRouteOptions());
    _routes.putIfAbsent(name, () => options);
  }

  /// 自定义bottomSheet路由
  void addBottomSheetPageRoute(String name, RouteWidgetBuilder builder,
      {BottomSheetRouteOptions? pageRouteOptions}) {
    RouteOptions<BottomSheetRouteOptions> options = RouteOptions<BottomSheetRouteOptions>(
        builder, pageRouteOptions ?? BottomSheetRouteOptions());
    _routes.putIfAbsent(name, () => options);
  }

  void install() {
    // print('MixinRouteContainer Install routers');
  }
}
