import 'package:hz_router_plugin_example/home/root_page.dart';
import 'package:hz_router_plugin_example/router/router_container.dart';
import 'package:hz_router_plugin_example/router/router_page.dart';

mixin HomeRouter on MixinRouteContainer {
  @override
  void install() {
    super.install();
    addRoute("homePage", (arguments) => HomePage());
    addRoute("rootPage", (arguments) => const RootPage());
  }
}
