import 'package:hz_router_plugin_example/mine/mine_page.dart';
import 'package:hz_router_plugin_example/router/route_registry.dart';

mixin MineRouter on RouteRegistry {
  @override
  void install() {
    super.install();
    addRoute("minePage", (arguments) => MinePage());
  }
}
