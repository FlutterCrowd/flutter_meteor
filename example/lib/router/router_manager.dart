import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meteor/navigator/impl/flutter.dart';
import 'package:hz_router_plugin_example/router/common.dart';

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
    RouteOptions<MaterialPageRouteOptions> routeOptions = RouteOptions<MaterialPageRouteOptions>(
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
    RouteOptions<CupertinoPageRouteOptions> routeOptions = RouteOptions<CupertinoPageRouteOptions>(
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
    RouterManager.routes.putIfAbsent(name, () => routeOptions);
  }

  /// PageRouteBuilder
  void setUnknownRoute(RouteWidgetBuilder builder) {
    CustomPageRouteOptions options = CustomPageRouteOptions(
      opaque: false,
    );
    RouteOptions<CustomPageRouteOptions> routeOptions =
        RouteOptions<CustomPageRouteOptions>(builder, options);
    RouterManager.routes.putIfAbsent("UnknownRouteName", () => routeOptions);
  }
}

class RouterManager {
  // 私有化构造方法，防止外部直接实例化
  RouterManager._internal();

  // 定义一个静态变量来存储唯一的实例
  static final RouterManager _instance = RouterManager._internal();

  // 提供一个工厂构造函数，返回唯一的实例
  factory RouterManager() {
    return _instance;
  }

  final Map<String, RouteOptions> _routes = {};
  static Map<String, RouteOptions> get routes => _instance._routes;

  /// 默认自定义动画
  static const defaultTransitionDuration = Duration(milliseconds: 250);
  // static final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
  static RouteWidgetBuilder? notFoundHandler;

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final String? name = settings.name;
    RouteOptions? options = routes[name];
    if (name == null || options == null) {
      options = routes['UnknownRouteName'];
      if (options == null) {
        return _notFoundRoute('UnknownRouteName', maintainState: true);
      } else {
        return _buildCustomPageRouteBuilder(settings, options, options.pageOptions);
      }
    }

    final pageOptions = options.pageOptions;

    if (pageOptions is MaterialPageRouteOptions) {
      return _buildMaterialPageRoute(settings, options, pageOptions);
    } else if (pageOptions is CupertinoPageRouteOptions) {
      return _buildCupertinoPageRoute(settings, options, pageOptions);
    } else if (pageOptions is StandardPageRouteOptions) {
      return _buildStandardPageRouteBuilder(settings, options, pageOptions);
    } else if (pageOptions is CustomPageRouteOptions) {
      return _buildCustomPageRouteBuilder(settings, options, pageOptions);
    } else if (pageOptions is DialogRouteOptions) {
      return _buildDialogRoute(settings, options, pageOptions);
    } else if (pageOptions is BottomSheetRouteOptions) {
      return _buildModalBottomSheetRoute(settings, options, pageOptions);
    } else {
      return _notFoundRoute(name, maintainState: true);
    }
  }

  static MaterialPageRoute _buildMaterialPageRoute(
    RouteSettings settings,
    RouteOptions options,
    MaterialPageRouteOptions pageRouteOptions,
  ) {
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
    RouteSettings settings,
    RouteOptions options,
    CupertinoPageRouteOptions pageRouteOptions,
  ) {
    return CupertinoPageRoute(
      settings: settings,
      maintainState: pageRouteOptions.maintainState ?? true,
      fullscreenDialog: pageRouteOptions.fullscreenDialog ?? false,
      allowSnapshotting: pageRouteOptions.allowSnapshotting ?? true,
      barrierDismissible: pageRouteOptions.barrierDismissible ?? false,
      builder: (context) => options.builder(settings.arguments as Map<String, dynamic>?),
    );
  }

  static PageRouteBuilder _buildStandardPageRouteBuilder(
    RouteSettings settings,
    RouteOptions options,
    StandardPageRouteOptions pageRouteOptions,
  ) {
    return PageRouteBuilder(
      opaque: pageRouteOptions.opaque ?? true,
      settings: settings,
      transitionsBuilder: _standardTransitionsBuilder(pageRouteOptions.transitionType),
      transitionDuration: pageRouteOptions.transitionDuration,
      reverseTransitionDuration: pageRouteOptions.reverseTransitionDuration,
      barrierLabel: pageRouteOptions.barrierLabel,
      barrierColor: pageRouteOptions.barrierColor,
      maintainState: pageRouteOptions.maintainState ?? true,
      fullscreenDialog: pageRouteOptions.fullscreenDialog ?? false,
      allowSnapshotting: pageRouteOptions.allowSnapshotting ?? true,
      barrierDismissible: pageRouteOptions.barrierDismissible ?? false,
      pageBuilder: (context, _, __) => options.builder(settings.arguments as Map<String, dynamic>?),
    );
  }

  static PageRouteBuilder _buildCustomPageRouteBuilder(
    RouteSettings settings,
    RouteOptions options,
    CustomPageRouteOptions pageRouteOptions,
  ) {
    return PageRouteBuilder(
      opaque: pageRouteOptions.opaque ?? true,
      settings: settings,
      transitionsBuilder: pageRouteOptions.transitionsBuilder ?? _customTransitionsBuilder,
      transitionDuration: pageRouteOptions.transitionDuration ?? defaultTransitionDuration,
      reverseTransitionDuration:
          pageRouteOptions.reverseTransitionDuration ?? defaultTransitionDuration,
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
    RouteSettings settings,
    RouteOptions options,
    DialogRouteOptions pageRouteOptions,
  ) {
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
    RouteSettings settings,
    RouteOptions options,
    BottomSheetRouteOptions pageRouteOptions,
  ) {
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

  static MaterialPageRoute<void> _notFoundRoute(
    String routeName, {
    bool? maintainState,
  }) {
    creator(
      RouteSettings? routeSettings,
      Map<String, List<String>> parameters,
    ) {
      return MaterialPageRoute<void>(
        settings: routeSettings,
        maintainState: maintainState ?? true,
        builder: (BuildContext context) {
          return notFoundHandler?.call(parameters) ?? const SizedBox.shrink();
        },
      );
    }

    return creator(RouteSettings(name: routeName), {});
  }

  static RouteTransitionsBuilder _standardTransitionsBuilder(FMTransitionType? transitionType) {
    return (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) {
      if (transitionType == FMTransitionType.fadeIn) {
        return FadeTransition(opacity: animation, child: child);
      } else {
        const topLeft = Offset(0.0, 0.0);
        const topRight = Offset(1.0, 0.0);
        const bottomLeft = Offset(0.0, 1.0);

        var startOffset = bottomLeft;
        var endOffset = topLeft;

        if (transitionType == FMTransitionType.inFromLeft) {
          startOffset = const Offset(-1.0, 0.0);
          endOffset = topLeft;
        } else if (transitionType == FMTransitionType.inFromRight) {
          startOffset = topRight;
          endOffset = topLeft;
        } else if (transitionType == FMTransitionType.inFromBottom) {
          startOffset = bottomLeft;
          endOffset = topLeft;
        } else if (transitionType == FMTransitionType.inFromTop) {
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

  static Widget _customTransitionsBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
