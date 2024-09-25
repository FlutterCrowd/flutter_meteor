import 'package:hz_router_plugin_example/navigator/router_type_page.dart';
import 'package:hz_router_plugin_example/router/router_manager.dart';

import 'multi_engine_page.dart';
import 'multi_engine_page2.dart';
import 'multi_engine_page3.dart';
import 'multi_engine_page4.dart';
import 'multi_engine_page5.dart';

mixin MultiEngineRouter on RouteRegistry {
  @override
  void install() {
    super.install();
    addRoute(
      "multiEnginePage",
      (arguments) => const MultiEnginePage(),
    );
    addRoute(
      "multiEnginePage2",
      (arguments) => const MultiEnginePage2(),
    );
    addRoute(
      "multiEnginePage3",
      (arguments) => const MultiEnginePage3(),
    );
    addRoute(
      "multiEnginePage4",
      (arguments) => const MultiEnginePage4(),
    );
    addRoute(
      "multiEnginePage5",
      (arguments) => const MultiEnginePage5(),
    );
    addRoute(
      "routeTypePage",
      (arguments) => const RouteTypePage(),
    );
  }
}
