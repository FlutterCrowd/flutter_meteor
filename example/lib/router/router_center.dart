import 'package:flutter/material.dart';
import 'package:flutter_meteor/navigator/impl/flutter.dart';
import 'package:hz_router_plugin_example/router/route_options.dart';
// import 'package:taxi_driver/common/global/global_variable.dart';
// import 'package:taxi_driver/common/router/container/router_container.dart';
//
// import '../common/router/container/route_options.dart';
// import '../common/router/root_router.dart';
// import '../common/ui/policy/router.dart';
// import '../main_page.dart';
// import '../sections/account/account_router_mediator.dart';
// import '../sections/home/router/home_router_mediator.dart';
// import '../sections/join/join_router_mediator.dart';
// import '../sections/trip/trip_router_mediator.dart';
// import '../sections/wallet/wallet_router_mediator.dart';

Widget _customTransitionsBuilder(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  return child;
}

class RouterCenter {
  get mixinRoutes => null;

  static setup() {
    debugPrint('RouterCenter Install routes:$routes');
  }

  static Map<String, RouteOptions> get routes => {};

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final String? name = settings.name;
    final RouteOptions? options = routes[name];
    if (options != null) {
      // bool opaque = options.opaque;
      if (options.pageOptions is MaterialPageRouteOptions) {
        MaterialPageRouteOptions pageRouteOptions = options.pageOptions;
        return MaterialPageRoute(
          settings: settings,
          maintainState: pageRouteOptions.maintainState ?? true,
          fullscreenDialog: pageRouteOptions.fullscreenDialog ?? false,
          allowSnapshotting: pageRouteOptions.allowSnapshotting ?? true,
          barrierDismissible: pageRouteOptions.barrierDismissible ?? false,
          builder: (context) => options.builder(settings.arguments as Map<String, dynamic>?),
        );
      } else if (options.pageOptions is PageRouteOptions) {
        PageRouteOptions pageRouteOptions = options.pageOptions;
        return PageRouteBuilder(
          opaque: pageRouteOptions.opaque ?? true,
          settings: settings,
          transitionsBuilder: pageRouteOptions.transitionsBuilder ?? _customTransitionsBuilder,
          transitionDuration:
              pageRouteOptions.transitionDuration ?? const Duration(milliseconds: 300),
          reverseTransitionDuration:
              pageRouteOptions.reverseTransitionDuration ?? const Duration(milliseconds: 300),
          barrierLabel: pageRouteOptions.barrierLabel,
          barrierColor: pageRouteOptions.barrierColor,
          maintainState: pageRouteOptions.maintainState ?? true,
          fullscreenDialog: pageRouteOptions.fullscreenDialog ?? false,
          allowSnapshotting: pageRouteOptions.allowSnapshotting ?? true,
          barrierDismissible: pageRouteOptions.barrierDismissible ?? false,
          pageBuilder: (context, _, __) =>
              options.builder(settings.arguments as Map<String, dynamic>?),
        );
      } else if (options.pageOptions is DialogRouteOptions) {
        DialogRouteOptions pageRouteOptions = options.pageOptions;
        BuildContext context = MeteorFlutterNavigator.rootKey!.currentContext!;
        final CapturedThemes themes = InheritedTheme.capture(
          from: context,
          to: Navigator.of(
            context,
            rootNavigator: pageRouteOptions.useRootNavigator ?? true,
          ).context,
        );
        return DialogRoute(
          context: context,
          settings: settings,
          barrierColor: pageRouteOptions.barrierColor,
          barrierLabel: pageRouteOptions.barrierLabel,
          useSafeArea: pageRouteOptions.useSafeArea ?? true,
          anchorPoint: pageRouteOptions.anchorPoint,
          traversalEdgeBehavior: pageRouteOptions.traversalEdgeBehavior,
          themes: themes,
          builder: (context) => options.builder(settings.arguments as Map<String, dynamic>?),
        );
      } else if (options.pageOptions is BottomSheetRouteOptions) {
        BottomSheetRouteOptions pageRouteOptions = options.pageOptions;
        BuildContext context = MeteorFlutterNavigator.rootKey!.currentContext!;
        final NavigatorState navigator =
            Navigator.of(context, rootNavigator: pageRouteOptions.useRootNavigator ?? false);
        final MaterialLocalizations localizations = MaterialLocalizations.of(context);
        return ModalBottomSheetRoute(
          builder: (context) => options.builder(settings.arguments as Map<String, dynamic>?),
          capturedThemes: InheritedTheme.capture(from: context, to: context),
          isScrollControlled: pageRouteOptions.isScrollControlled ?? false,
          scrollControlDisabledMaxHeightRatio:
              pageRouteOptions.scrollControlDisabledMaxHeightRatio ?? 9.0 / 16.0,
          barrierLabel: pageRouteOptions.barrierLabel ?? localizations.scrimLabel,
          barrierOnTapHint: localizations.scrimOnTapHint(localizations.bottomSheetLabel),
          backgroundColor: pageRouteOptions.backgroundColor,
          elevation: pageRouteOptions.elevation,
          shape: pageRouteOptions.shape,
          clipBehavior: pageRouteOptions.clipBehavior,
          constraints: pageRouteOptions.constraints,
          isDismissible: pageRouteOptions.isDismissible ?? true,
          modalBarrierColor:
              pageRouteOptions.barrierColor ?? Theme.of(context).bottomSheetTheme.modalBarrierColor,
          enableDrag: pageRouteOptions.enableDrag ?? false,
          showDragHandle: pageRouteOptions.showDragHandle,
          settings: settings,
          transitionAnimationController: pageRouteOptions.transitionAnimationController,
          anchorPoint: pageRouteOptions.anchorPoint,
          useSafeArea: pageRouteOptions.useSafeArea ?? false,
        );
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
