import 'package:hz_router_plugin_example/mine/mine_page.dart';
import 'package:hz_router_plugin_example/router/router_container.dart';

mixin MineRouter on MixinRouteContainer {
  @override
  void install() {
    super.install();
    addRoute("minePage", (arguments) => MinePage());
  }
}
