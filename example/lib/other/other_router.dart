import 'package:flutter/material.dart';
import 'package:hz_router_plugin_example/other/pop_window.dart';
import 'package:hz_router_plugin_example/other/webview_page.dart';
import 'package:hz_router_plugin_example/router/route_registry.dart';

import '../event_bus/event_bus_test_page.dart';
import '../router/config.dart';
import 'back_widget.dart';
import 'bottom_sheet_page.dart';

mixin OtherRouter on RouteRegistry {
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

    addRoute(
      'eventBusTestPage',
      (arguments) => const EventBusTestPage(),
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
      transitionType: MeteorTransitionType.inFromLeft,
    );

    addStandardPageRoute(
      'standardPageRoute_rtl',
      (arguments) => BackPage(),
      transitionType: MeteorTransitionType.inFromRight,
    );

    addStandardPageRoute(
      'standardPageRoute_top',
      (arguments) => BackPage(),
      transitionType: MeteorTransitionType.inFromTop,
    );

    addStandardPageRoute(
      'standardPageRoute_bottom',
      (arguments) => BackPage(),
      transitionType: MeteorTransitionType.inFromBottom,
    );

    addStandardPageRoute(
      'standardPageRoute_fadeIn',
      (arguments) => BackPage(),
      transitionType: MeteorTransitionType.fadeIn,
    );

    addRoute(
      'webViewPage',
      (arguments) => WebViewPage(
        url: arguments?['url'],
        title: '这是一个网页',
      ),
    );
  }
}
