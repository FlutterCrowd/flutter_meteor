import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meteor/navigator/impl/flutter.dart';

import 'route_config.dart';

typedef RouteWidgetBuilder = Widget Function(Map<String, dynamic>? arguments);

class RouteOptions {
  final RouteWidgetBuilder builder;
  final BaseRouteOptions pageOptions;
  RouteOptions(this.builder, this.pageOptions);

  Route<dynamic>? createRoute(RouteSettings settings) {
    return pageOptions.createRoute(settings, this);
  }
}

mixin BaseRouteOptions {
  Route<dynamic> createRoute(RouteSettings settings, RouteOptions options);
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

class MaterialPageRouteOptions extends PageRouteOptions with BaseRouteOptions {
  MaterialPageRouteOptions({
    super.maintainState,
    super.fullscreenDialog,
    super.allowSnapshotting,
    super.barrierDismissible,
  });

  @override
  Route<dynamic> createRoute(RouteSettings settings, RouteOptions options) {
    return MaterialPageRoute(
      settings: settings,
      maintainState: maintainState ?? true,
      fullscreenDialog: fullscreenDialog ?? false,
      allowSnapshotting: allowSnapshotting ?? true,
      barrierDismissible: barrierDismissible ?? false,
      builder: (context) => options.builder(settings.arguments as Map<String, dynamic>?),
    );
  }
}

class CupertinoPageRouteOptions extends PageRouteOptions with BaseRouteOptions {
  CupertinoPageRouteOptions({
    super.maintainState,
    super.fullscreenDialog,
    super.allowSnapshotting,
    super.barrierDismissible,
  });
  @override
  Route createRoute(RouteSettings settings, RouteOptions options) {
    return CupertinoPageRoute(
      settings: settings,
      maintainState: maintainState ?? true,
      fullscreenDialog: fullscreenDialog ?? false,
      allowSnapshotting: allowSnapshotting ?? true,
      barrierDismissible: barrierDismissible ?? false,
      builder: (context) => options.builder(settings.arguments as Map<String, dynamic>?),
    );
  }
}

class StandardPageRouteOptions extends PageRouteOptions with BaseRouteOptions {
  static const defaultTransitionDuration = Duration(milliseconds: 250);
  final MeteorTransitionType? transitionType;
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

  @override
  Route createRoute(RouteSettings settings, RouteOptions options) {
    return PageRouteBuilder(
      opaque: opaque ?? true,
      settings: settings,
      transitionsBuilder: _standardTransitionsBuilder(transitionType),
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
      barrierLabel: barrierLabel,
      barrierColor: barrierColor,
      maintainState: maintainState ?? true,
      fullscreenDialog: fullscreenDialog ?? false,
      allowSnapshotting: allowSnapshotting ?? true,
      barrierDismissible: barrierDismissible ?? false,
      pageBuilder: (context, _, __) => options.builder(settings.arguments as Map<String, dynamic>?),
    );
  }

  static RouteTransitionsBuilder _standardTransitionsBuilder(MeteorTransitionType? transitionType) {
    return (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) {
      if (transitionType == MeteorTransitionType.fadeIn) {
        return FadeTransition(opacity: animation, child: child);
      } else {
        const topLeft = Offset(0.0, 0.0);
        const topRight = Offset(1.0, 0.0);
        const bottomLeft = Offset(0.0, 1.0);

        var startOffset = bottomLeft;
        var endOffset = topLeft;

        if (transitionType == MeteorTransitionType.inFromLeft) {
          startOffset = const Offset(-1.0, 0.0);
          endOffset = topLeft;
        } else if (transitionType == MeteorTransitionType.inFromRight) {
          startOffset = topRight;
          endOffset = topLeft;
        } else if (transitionType == MeteorTransitionType.inFromBottom) {
          startOffset = bottomLeft;
          endOffset = topLeft;
        } else if (transitionType == MeteorTransitionType.inFromTop) {
          startOffset = const Offset(0.0, -1.0);
          endOffset = topLeft;
        }
        return SlideTransition(
          position: Tween<Offset>(
            begin: startOffset,
            end: endOffset,
          ).animate(animation),
          child: child,
        );
      }
    };
  }
}

class CustomPageRouteOptions extends PageRouteOptions with BaseRouteOptions {
  /// 默认自定义动画持续时间
  static const defaultTransitionDuration = Duration(milliseconds: 300);

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

  @override
  Route createRoute(RouteSettings settings, RouteOptions options) {
    return PageRouteBuilder(
      opaque: opaque ?? true,
      settings: settings,
      transitionsBuilder: transitionsBuilder ?? _customTransitionsBuilder,
      transitionDuration: transitionDuration ?? defaultTransitionDuration,
      reverseTransitionDuration: reverseTransitionDuration ?? defaultTransitionDuration,
      barrierLabel: barrierLabel,
      barrierColor: barrierColor,
      maintainState: maintainState ?? true,
      fullscreenDialog: fullscreenDialog ?? false,
      allowSnapshotting: allowSnapshotting ?? true,
      barrierDismissible: barrierDismissible ?? false,
      pageBuilder: (context, _, __) => options.builder(settings.arguments as Map<String, dynamic>?),
    );
  }

  static Widget _customTransitionsBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

class DialogRouteOptions with BaseRouteOptions {
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
  @override
  Route<dynamic> createRoute(RouteSettings settings, RouteOptions options) {
    BuildContext context = MeteorFlutterNavigator.rootKey!.currentContext!;
    final CapturedThemes themes = InheritedTheme.capture(
      from: context,
      to: Navigator.of(context, rootNavigator: useRootNavigator ?? true).context,
    );
    return DialogRoute(
      context: context,
      settings: settings,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea ?? true,
      anchorPoint: anchorPoint,
      traversalEdgeBehavior: traversalEdgeBehavior,
      themes: themes,
      builder: (context) => options.builder(settings.arguments as Map<String, dynamic>?),
    );
  }
}

class BottomSheetRouteOptions with BaseRouteOptions {
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

  @override
  Route<dynamic> createRoute(RouteSettings settings, RouteOptions options) {
    BuildContext context = MeteorFlutterNavigator.rootKey!.currentContext!;
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);

    return ModalBottomSheetRoute(
      builder: (context) => options.builder(settings.arguments as Map<String, dynamic>?),
      capturedThemes: InheritedTheme.capture(from: context, to: context),
      isScrollControlled: isScrollControlled ?? false,
      scrollControlDisabledMaxHeightRatio: scrollControlDisabledMaxHeightRatio ?? 9.0 / 16.0,
      barrierLabel: barrierLabel ?? localizations.scrimLabel,
      barrierOnTapHint: localizations.scrimOnTapHint(localizations.bottomSheetLabel),
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      constraints: constraints,
      isDismissible: isDismissible ?? true,
      modalBarrierColor: barrierColor ?? Theme.of(context).bottomSheetTheme.modalBarrierColor,
      enableDrag: enableDrag ?? false,
      showDragHandle: showDragHandle,
      settings: settings,
      transitionAnimationController: transitionAnimationController,
      anchorPoint: anchorPoint,
      useSafeArea: useSafeArea ?? false,
    );
  }
}
