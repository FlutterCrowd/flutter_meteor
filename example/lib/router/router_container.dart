import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hz_router_plugin_example/router/common.dart';

class MixinRouteContainer {
  final Map<String, RouteOptions> _routes = {};
  Map<String, RouteOptions> get mixinRoutes => _routes;

  void addRoutes(Map<String, RouteOptions> routes) {
    _routes.addAll(routes);
  }

  /// MaterialPageRoute
  void addRoute(
    String name,
    RouteWidgetBuilder builder, {
    FMStandardRouteType? routeType = FMStandardRouteType.native,
  }) {
    if (routeType == FMStandardRouteType.material) {
      addMaterialPageRoute(name, builder);
    } else if (routeType == FMStandardRouteType.material) {
      addCupertinoPageRoute(name, builder);
    } else if (routeType == FMStandardRouteType.dialog) {
      addDialogPageRoute(name, builder);
    } else if (routeType == FMStandardRouteType.bottomSheet) {
      addBottomSheetPageRoute(name, builder);
    } else if (routeType == FMStandardRouteType.native) {
      if (Platform.isIOS) {
        addCupertinoPageRoute(name, builder);
      } else {
        addMaterialPageRoute(name, builder);
      }
    } else {
      print('Unknown routeType: $routeType');
    }
  }

  /// PageRouteBuilder
  void addTransparentRoute(String name, RouteWidgetBuilder builder) {
    CustomPageRouteOptions options = CustomPageRouteOptions(
      opaque: false,
    );
    RouteOptions<CustomPageRouteOptions> routeOptions =
        RouteOptions<CustomPageRouteOptions>(builder, options);
    _routes.putIfAbsent(name, () => routeOptions);
  }

  /// MaterialPageRoute
  void addMaterialPageRoute(
    String name,
    RouteWidgetBuilder builder, {
    bool? maintainState = true,
    bool? fullscreenDialog = false,
    bool? allowSnapshotting = true,
    bool? barrierDismissible = false,
  }) {
    RouteOptions<MaterialPageRouteOptions> routeOptions = RouteOptions<MaterialPageRouteOptions>(
        builder,
        MaterialPageRouteOptions(
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
          allowSnapshotting: allowSnapshotting,
          barrierDismissible: barrierDismissible,
        ));
    _routes.putIfAbsent(name, () => routeOptions);
  }

  void addCupertinoPageRoute(
    String name,
    RouteWidgetBuilder builder, {
    bool? maintainState = true,
    bool? fullscreenDialog = false,
    bool? allowSnapshotting = true,
    bool? barrierDismissible = false,
  }) {
    RouteOptions<CupertinoPageRouteOptions> routeOptions = RouteOptions<CupertinoPageRouteOptions>(
        builder,
        CupertinoPageRouteOptions(
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
          allowSnapshotting: allowSnapshotting,
          barrierDismissible: barrierDismissible,
        ));
    _routes.putIfAbsent(name, () => routeOptions);
  }

  /// PageRouteBuilder
  void addStandardPageRoute(
    String name,
    RouteWidgetBuilder builder, {
    FMTransitionType? transitionType = FMTransitionType.inFromRight,
    bool? opaque = true,
    Color? barrierColor,
    String? barrierLabel,
    bool? maintainState = true,
    bool? fullscreenDialog = false,
    bool? allowSnapshotting = true,
    bool? barrierDismissible = false,
  }) {
    RouteOptions<StandardPageRouteOptions> routeOptions = RouteOptions<StandardPageRouteOptions>(
        builder,
        StandardPageRouteOptions(
          transitionType: transitionType,
          opaque: opaque,
          barrierColor: barrierColor,
          barrierLabel: barrierLabel,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
          allowSnapshotting: allowSnapshotting,
          barrierDismissible: barrierDismissible,
        ));
    _routes.putIfAbsent(name, () => routeOptions);
  }

  /// PageRouteBuilder
  void addCustomPageRoute(
    String name,
    RouteWidgetBuilder builder, {
    RouteTransitionsBuilder? transitionsBuilder,
    Duration? transitionDuration = const Duration(milliseconds: 300),
    Duration? reverseTransitionDuration = const Duration(milliseconds: 300),
    bool? opaque = true,
    Color? barrierColor,
    String? barrierLabel,
    bool? maintainState = true,
    bool? fullscreenDialog = false,
    bool? allowSnapshotting = true,
    bool? barrierDismissible = false,
  }) {
    RouteOptions<CustomPageRouteOptions> routeOptions = RouteOptions<CustomPageRouteOptions>(
        builder,
        CustomPageRouteOptions(
          transitionsBuilder: transitionsBuilder,
          transitionDuration: transitionDuration,
          reverseTransitionDuration: reverseTransitionDuration,
          opaque: opaque,
          barrierColor: barrierColor,
          barrierLabel: barrierLabel,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
          allowSnapshotting: allowSnapshotting,
          barrierDismissible: barrierDismissible,
        ));
    _routes.putIfAbsent(name, () => routeOptions);
  }

  /// 自定义Dialog路由
  void addDialogPageRoute(
    String name,
    RouteWidgetBuilder builder, {
    CapturedThemes? themes,
    Color barrierColor = Colors.black54,
    barrierDismissible = false,
    String? barrierLabel,
    bool? useSafeArea = true,
    Offset? anchorPoint,
    TraversalEdgeBehavior? traversalEdgeBehavior,
  }) {
    RouteOptions<DialogRouteOptions> routeOptions = RouteOptions<DialogRouteOptions>(
      builder,
      DialogRouteOptions(
        themes: themes,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        useSafeArea: useSafeArea,
        anchorPoint: anchorPoint,
        traversalEdgeBehavior: traversalEdgeBehavior,
      ),
    );
    _routes.putIfAbsent(name, () => routeOptions);
  }

  /// 自定义bottomSheet路由
  void addBottomSheetPageRoute(
    String name,
    RouteWidgetBuilder builder, {
    InheritedTheme? capturedThemes,
    Color? backgroundColor,
    final double? elevation,
    final ShapeBorder? shape,
    final Clip? clipBehavior,
    final BoxConstraints? constraints,
    final bool? isScrollControlled,
    final bool? isDismissible,
    final bool? enableDrag,
    final bool? showDragHandle,
    final bool? useSafeArea,
    final Color? barrierColor,
    final String? barrierLabel,
    final bool? useRootNavigator,
    final Offset? anchorPoint,
    final double? scrollControlDisabledMaxHeightRatio = 9.0 / 16.0,
    final TraversalEdgeBehavior? traversalEdgeBehavior,
    final AnimationController? transitionAnimationController,
  }) {
    RouteOptions<BottomSheetRouteOptions> routeOptions = RouteOptions<BottomSheetRouteOptions>(
      builder,
      BottomSheetRouteOptions(
        capturedThemes: capturedThemes,
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: shape,
        clipBehavior: clipBehavior,
        constraints: constraints,
        isScrollControlled: isScrollControlled,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        showDragHandle: showDragHandle,
        useSafeArea: useSafeArea,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        useRootNavigator: useRootNavigator,
        anchorPoint: anchorPoint,
        scrollControlDisabledMaxHeightRatio: scrollControlDisabledMaxHeightRatio,
        traversalEdgeBehavior: traversalEdgeBehavior,
        transitionAnimationController: transitionAnimationController,
      ),
    );
    _routes.putIfAbsent(name, () => routeOptions);
  }

  /// PageRouteBuilder
  void addUnknownRoute(RouteWidgetBuilder builder) {
    CustomPageRouteOptions options = CustomPageRouteOptions(
      opaque: false,
    );
    RouteOptions<CustomPageRouteOptions> routeOptions =
        RouteOptions<CustomPageRouteOptions>(builder, options);
    _routes.putIfAbsent("UnknownRouteName", () => routeOptions);
  }

  void install() {
    // print('MixinRouteContainer Install routers');
  }
}
