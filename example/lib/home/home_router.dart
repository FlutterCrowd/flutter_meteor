import 'package:hz_router_plugin_example/event_bus/event_bus_test_page.dart';
import 'package:hz_router_plugin_example/home/home_page.dart';
import 'package:hz_router_plugin_example/router/route_registry.dart';

import '../route_demo/router_type_page.dart';
import '../shared_cache/shared_cache_test_widget.dart';
import '../shared_state/global_singleton_test_page.dart';
import '../shared_state/global_singleton_test_page2.dart';
import '../shared_state/share_state_page1.dart';
import '../shared_state/share_state_page2.dart';

mixin HomeRouter on RouteRegistry {
  @override
  void install() {
    super.install();
    addRoute("homePage", (arguments) => const HomePage());

    addRoute("routeTypePage", (arguments) => const RouteTypePage());
    addRoute('eventBusTestPage', (arguments) => const EventBusTestPage());

    addRoute('sharedCacheTestPage', (arguments) => const SharedCacheTestPage());

    addRoute(
      "shareStatePage1",
      (arguments) => const ShareStatePage1(),
    );

    addRoute(
      "shareStatePage2",
      (arguments) => ShareStatePage2(),
    );

    addRoute(
      "globalSingletonStatePage",
      (arguments) => const GlobalSingletonStatePage(),
    );

    addRoute(
      "globalSingletonStatePage2",
      (arguments) => const GlobalSingletonStatePage2(),
    );
  }
}
