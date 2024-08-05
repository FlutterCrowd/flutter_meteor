import 'dart:ui';

import 'package:hz_router_plugin_example/other/pop_window.dart';
import 'package:hz_router_plugin_example/other/webview_page.dart';
import 'package:hz_router_plugin_example/router/common.dart';
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

    addDialogPageRoute(
      'dialogWindowPage',
      (arguments) => const PopWindowPage(),
      anchorPoint: const Offset(100, 200),
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
    );

    addCupertinoPageRoute(
      'cupertinoPageRoute',
      (arguments) => BackPage(),
    );

    addCustomPageRoute(
      'customPageRoute',
      (arguments) => BackPage(),
    );

    addStandardPageRoute(
      'standardPageRoute_ltr',
      (arguments) => BackPage(),
      transitionType: FMTransitionType.inFromLeft,
    );

    addStandardPageRoute(
      'standardPageRoute_rtl',
      (arguments) => BackPage(),
      transitionType: FMTransitionType.inFromRight,
    );

    addStandardPageRoute(
      'standardPageRoute_top',
      (arguments) => BackPage(),
      transitionType: FMTransitionType.inFromTop,
    );

    addStandardPageRoute(
      'standardPageRoute_bottom',
      (arguments) => BackPage(),
      transitionType: FMTransitionType.inFromBottom,
    );

    addStandardPageRoute(
      'standardPageRoute_fadeIn',
      (arguments) => BackPage(),
      transitionType: FMTransitionType.fadeIn,
    );

    addRoute(
      'webViewPage',
      (arguments) => WebViewPage(
        url: arguments?['url'],
      ),
    );
  }
}
