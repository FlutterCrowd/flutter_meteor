import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_meteor/router/router.dart';

abstract class RouteRegistry {
  void install() {}
  void addRoutes(Map<String, RouteOptions> routes) {
    // RouterManager.addRoutes(routes);
    RouterManager.routes.addAll(routes);
  }

  /// MaterialPageRoute
  void addRoute(
    String name,
    RouteWidgetBuilder builder, {
    MeteorRouteType? routeType = MeteorRouteType.native,
  }) {
    if (routeType == MeteorRouteType.material) {
      addMaterialPageRoute(name, builder);
    } else if (routeType == MeteorRouteType.cupertino) {
      addCupertinoPageRoute(name, builder);
    } else if (routeType == MeteorRouteType.dialog) {
      addDialogPageRoute(name, builder);
    } else if (routeType == MeteorRouteType.bottomSheet) {
      addBottomSheetPageRoute(name, builder);
    } else if (routeType == MeteorRouteType.native) {
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
    RouteOptions routeOptions = RouteOptions(builder, options);
    RouterManager.routes.putIfAbsent(name, () => routeOptions);
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
    RouteOptions routeOptions = RouteOptions(
        builder,
        MaterialPageRouteOptions(
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
          allowSnapshotting: allowSnapshotting,
          barrierDismissible: barrierDismissible,
        ));
    RouterManager.routes.putIfAbsent(name, () => routeOptions);
  }

  void addCupertinoPageRoute(
    String name,
    RouteWidgetBuilder builder, {
    bool? maintainState = true,
    bool? fullscreenDialog = false,
    bool? allowSnapshotting = true,
    bool? barrierDismissible = false,
  }) {
    RouteOptions routeOptions = RouteOptions(
        builder,
        CupertinoPageRouteOptions(
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
          allowSnapshotting: allowSnapshotting,
          barrierDismissible: barrierDismissible,
        ));
    RouterManager.routes.putIfAbsent(name, () => routeOptions);
  }

  /// PageRouteBuilder
  void addStandardPageRoute(
    String name,
    RouteWidgetBuilder builder, {
    MeteorTransitionType? transitionType = MeteorTransitionType.inFromRight,
    bool? opaque = true,
    Color? barrierColor,
    String? barrierLabel,
    bool? maintainState = true,
    bool? fullscreenDialog = false,
    bool? allowSnapshotting = true,
    bool? barrierDismissible = false,
  }) {
    RouteOptions routeOptions = RouteOptions(
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
    RouterManager.routes.putIfAbsent(name, () => routeOptions);
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
    RouteOptions routeOptions = RouteOptions(
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
    RouterManager.routes.putIfAbsent(name, () => routeOptions);
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
    RouteOptions routeOptions = RouteOptions(
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
    RouterManager.routes.putIfAbsent(name, () => routeOptions);
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
    RouteOptions routeOptions = RouteOptions(
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
    RouterManager.routes.putIfAbsent(name, () => routeOptions);
  }
}
