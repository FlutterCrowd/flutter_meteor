import 'package:hz_router_plugin_example/multi_engine/multi_engin_page.dart';
import 'package:hz_router_plugin_example/router/router_container.dart';

import 'multi_engin_page2.dart';

mixin MultiEngineRouter on MixinRouteContainer {
  @override
  void install() {
    super.install();
    addRoute("multiEnginePage", (arguments) => MultiEnginPage());
    addRoute("multiEnginePage2", (arguments) => const MultiEnginPage2());
  }
}
