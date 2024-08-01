import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meteor/navigator/impl/flutter.dart';
import 'package:hz_router_plugin_example/home/home_router.dart';
import 'package:hz_router_plugin_example/mine/mine_router.dart';
import 'package:hz_router_plugin_example/multi_engine/multi_engine_router.dart';
import 'package:hz_router_plugin_example/other/other_router.dart';
import 'package:hz_router_plugin_example/router/route_options.dart';
import 'package:hz_router_plugin_example/router/router_container.dart';

Widget _customTransitionsBuilder(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  return child;
}

class RouterCenter extends MixinRouteContainer
    with HomeRouter, MineRouter, MultiEngineRouter, OtherRouter {
  static final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  RouterCenter._() {
    // install();
  }

  static final RouterCenter _instance = RouterCenter._();

  static void setup() {
    _instance.install();
    debugPrint('RouterCenter Install routes:$routes');
  }

  static Map<String, RouteOptions> get routes => _instance.mixinRoutes;

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final String? name = settings.name;
    final RouteOptions? options = routes[name];

    if (options == null) {
      return null;
    }

    final pageOptions = options.pageOptions;
    if (pageOptions is MaterialPageRouteOptions) {
      return _buildMaterialPageRoute(settings, options, pageOptions);
    } else if (pageOptions is CupertinoPageRouteOptions) {
      return _buildCupertinoPageRoute(settings, options, pageOptions);
    } else if (pageOptions is PageRouteBuilderOptions) {
      return _buildPageRouteBuilder(settings, options, pageOptions);
    } else if (pageOptions is DialogRouteOptions) {
      return _buildDialogRoute(settings, options, pageOptions);
    } else if (pageOptions is BottomSheetRouteOptions) {
      return _buildModalBottomSheetRoute(settings, options, pageOptions);
    } else {
      return null;
    }
  }

  static MaterialPageRoute _buildMaterialPageRoute(
      RouteSettings settings, RouteOptions options, MaterialPageRouteOptions pageRouteOptions) {
    return MaterialPageRoute(
      settings: settings,
      maintainState: pageRouteOptions.maintainState ?? true,
      fullscreenDialog: pageRouteOptions.fullscreenDialog ?? false,
      allowSnapshotting: pageRouteOptions.allowSnapshotting ?? true,
      barrierDismissible: pageRouteOptions.barrierDismissible ?? false,
      builder: (context) => options.builder(settings.arguments as Map<String, dynamic>?),
    );
  }

  static CupertinoPageRoute _buildCupertinoPageRoute(
      RouteSettings settings, RouteOptions options, CupertinoPageRouteOptions pageRouteOptions) {
    return CupertinoPageRoute(
      settings: settings,
      maintainState: pageRouteOptions.maintainState ?? true,
      fullscreenDialog: pageRouteOptions.fullscreenDialog ?? false,
      allowSnapshotting: pageRouteOptions.allowSnapshotting ?? true,
      barrierDismissible: pageRouteOptions.barrierDismissible ?? false,
      builder: (context) => options.builder(settings.arguments as Map<String, dynamic>?),
    );
  }

  static PageRouteBuilder _buildPageRouteBuilder(
      RouteSettings settings, RouteOptions options, PageRouteBuilderOptions pageRouteOptions) {
    return PageRouteBuilder(
      opaque: pageRouteOptions.opaque ?? true,
      settings: settings,
      transitionsBuilder: pageRouteOptions.transitionsBuilder ?? _customTransitionsBuilder,
      transitionDuration: pageRouteOptions.transitionDuration ?? const Duration(milliseconds: 250),
      reverseTransitionDuration:
          pageRouteOptions.reverseTransitionDuration ?? const Duration(milliseconds: 250),
      barrierLabel: pageRouteOptions.barrierLabel,
      barrierColor: pageRouteOptions.barrierColor,
      maintainState: pageRouteOptions.maintainState ?? true,
      fullscreenDialog: pageRouteOptions.fullscreenDialog ?? false,
      allowSnapshotting: pageRouteOptions.allowSnapshotting ?? true,
      barrierDismissible: pageRouteOptions.barrierDismissible ?? false,
      pageBuilder: (context, _, __) => options.builder(settings.arguments as Map<String, dynamic>?),
    );
  }

  static DialogRoute _buildDialogRoute(
      RouteSettings settings, RouteOptions options, DialogRouteOptions pageRouteOptions) {
    BuildContext context = MeteorFlutterNavigator.rootKey!.currentContext!;
    final CapturedThemes themes = InheritedTheme.capture(
      from: context,
      to: Navigator.of(context, rootNavigator: pageRouteOptions.useRootNavigator ?? true).context,
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
  }

  static ModalBottomSheetRoute _buildModalBottomSheetRoute(
      RouteSettings settings, RouteOptions options, BottomSheetRouteOptions pageRouteOptions) {
    BuildContext context = MeteorFlutterNavigator.rootKey!.currentContext!;
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
  }
}
