import 'package:flutter/cupertino.dart';

typedef RouteWidgetBuilder = Widget Function(Map<String, dynamic>? arguments);

class RouteOptions<T> {
  final RouteWidgetBuilder builder;
  final T pageOptions;
  RouteOptions(this.builder, this.pageOptions);

  bool get isMaterial => pageOptions is MaterialPageRouteOptions;
}

class MaterialPageRouteOptions {
  final bool? maintainState;
  final bool? fullscreenDialog;
  final bool? allowSnapshotting;
  final bool? barrierDismissible;
  MaterialPageRouteOptions({
    this.maintainState,
    this.fullscreenDialog,
    this.allowSnapshotting,
    this.barrierDismissible,
  });
}

class PageRouteOptions {
  final RouteTransitionsBuilder? transitionsBuilder;
  final Duration? transitionDuration;
  final Duration? reverseTransitionDuration;
  final bool? opaque;
  final bool? barrierDismissible;
  final Color? barrierColor;
  final String? barrierLabel;
  final bool? maintainState;
  final bool? fullscreenDialog;
  final bool? allowSnapshotting;

  PageRouteOptions({
    this.transitionsBuilder,
    this.transitionDuration,
    this.reverseTransitionDuration,
    this.opaque,
    this.barrierDismissible,
    this.barrierColor,
    this.barrierLabel,
    this.maintainState,
    this.fullscreenDialog,
    this.allowSnapshotting,
  });
}

class DialogRouteOptions {
  final bool? barrierDismissible;
  final Color? barrierColor;
  final String? barrierLabel;
  final bool? useSafeArea;
  final bool? useRootNavigator;
  final Offset? anchorPoint;
  final TraversalEdgeBehavior? traversalEdgeBehavior;
  DialogRouteOptions({
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
