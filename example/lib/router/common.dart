import 'package:flutter/cupertino.dart';

typedef RouteWidgetBuilder = Widget Function(Map<String, dynamic>? arguments);

enum FMStandardRouteType {
  none,
  native,
  material,
  cupertino,
  dialog,
  bottomSheet,
}

enum FMTransitionType {
  inFromLeft,
  inFromTop,
  inFromRight,
  inFromBottom,
  fadeIn,
}

class RouteOptions<T> {
  final RouteWidgetBuilder builder;
  final T pageOptions;
  RouteOptions(this.builder, this.pageOptions);
}

class PageRouteOptions {
  final bool? maintainState;
  final bool? fullscreenDialog;
  final bool? allowSnapshotting;
  final bool? barrierDismissible;
  PageRouteOptions({
    this.maintainState,
    this.fullscreenDialog,
    this.allowSnapshotting,
    this.barrierDismissible,
  });
}

class MaterialPageRouteOptions extends PageRouteOptions {
  MaterialPageRouteOptions({
    super.maintainState,
    super.fullscreenDialog,
    super.allowSnapshotting,
    super.barrierDismissible,
  });
}

class CupertinoPageRouteOptions extends PageRouteOptions {
  CupertinoPageRouteOptions({
    super.maintainState,
    super.fullscreenDialog,
    super.allowSnapshotting,
    super.barrierDismissible,
  });
}

class StandardPageRouteOptions extends PageRouteOptions {
  static const defaultTransitionDuration = Duration(milliseconds: 250);
  final FMTransitionType? transitionType;
  final Duration transitionDuration = defaultTransitionDuration;
  final Duration reverseTransitionDuration = defaultTransitionDuration;
  final bool? opaque;
  final Color? barrierColor;
  final String? barrierLabel;

  StandardPageRouteOptions({
    this.transitionType,
    this.opaque,
    this.barrierColor,
    this.barrierLabel,
    super.maintainState,
    super.fullscreenDialog,
    super.allowSnapshotting,
    super.barrierDismissible,
  });
}

class CustomPageRouteOptions extends PageRouteOptions {
  final RouteTransitionsBuilder? transitionsBuilder;
  final Duration? transitionDuration;
  final Duration? reverseTransitionDuration;
  final bool? opaque;
  final Color? barrierColor;
  final String? barrierLabel;

  CustomPageRouteOptions({
    this.transitionsBuilder,
    this.transitionDuration,
    this.reverseTransitionDuration,
    this.opaque,
    this.barrierColor,
    this.barrierLabel,
    super.maintainState,
    super.fullscreenDialog,
    super.allowSnapshotting,
    super.barrierDismissible,
  });
}

class DialogRouteOptions {
  final CapturedThemes? themes;
  final bool? barrierDismissible;
  final Color? barrierColor;
  final String? barrierLabel;
  final bool? useSafeArea;
  final bool? useRootNavigator;
  final Offset? anchorPoint;
  final TraversalEdgeBehavior? traversalEdgeBehavior;
  DialogRouteOptions({
    this.themes,
    this.barrierDismissible,
    this.barrierColor,
    this.barrierLabel,
    this.useSafeArea,
    this.useRootNavigator,
    this.anchorPoint,
    this.traversalEdgeBehavior,
  });
}

class BottomSheetRouteOptions {
  final InheritedTheme? capturedThemes;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final BoxConstraints? constraints;
  final bool? isScrollControlled;
  final bool? isDismissible;
  final bool? enableDrag;
  final bool? showDragHandle;
  final bool? useSafeArea;
  final Color? barrierColor;
  final String? barrierLabel;
  final bool? useRootNavigator;
  final Offset? anchorPoint;
  final double? scrollControlDisabledMaxHeightRatio;
  final TraversalEdgeBehavior? traversalEdgeBehavior;
  final AnimationController? transitionAnimationController;
  BottomSheetRouteOptions({
    this.capturedThemes,
    this.backgroundColor,
    this.useSafeArea,
    this.useRootNavigator,
    this.enableDrag,
    this.elevation,
    this.shape,
    this.showDragHandle,
    this.anchorPoint,
    this.barrierColor,
    this.barrierLabel,
    this.constraints,
    this.isDismissible,
    this.clipBehavior,
    this.isScrollControlled,
    this.traversalEdgeBehavior,
    this.transitionAnimationController,
    this.scrollControlDisabledMaxHeightRatio,
  });
}

class RouteNotFoundException implements Exception {
  RouteNotFoundException(
    this.message,
    this.path,
  );

  final String message;
  final String path;

  @override
  String toString() {
    return "No registered route was found to handle '$path'";
  }
}
