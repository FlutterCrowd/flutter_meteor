import 'package:hz_router_plugin_example/other/pop_window.dart';
import 'package:hz_router_plugin_example/router/router_container.dart';

import 'back_widget.dart';
import 'bottom_sheet_page.dart';

mixin OtherRouter on MixinRouteContainer {
  @override
  void install() {
    super.install();
    addTransparentRoute(
      'popWindowPage',
      (arguments) => const PopWindowPage(),
    );
    addBottomSheetPageRoute(
      "bottomSheetPage",
      (arguments) => const BottomSheetPage(),
    );
    addRoute(
      'backPage',
      (arguments) => BackPage(),
    );

    addMaterialPageRoute(
      'materialPageRoute',
      (arguments) => BackPage(),
      maintainState: false,
      fullscreenDialog: false,
      allowSnapshotting: false,
      barrierDismissible: false,
    );

    addCupertinoPageRoute(
      'cupertinoPageRoute',
      (arguments) => BackPage(),
      maintainState: false,
      fullscreenDialog: false,
      allowSnapshotting: false,
      barrierDismissible: false,
    );

    addCustomPageRoute(
      'customPageRoute',
      (arguments) => BackPage(),
      maintainState: false,
      fullscreenDialog: false,
      allowSnapshotting: false,
      barrierDismissible: false,
    );
  }
}
