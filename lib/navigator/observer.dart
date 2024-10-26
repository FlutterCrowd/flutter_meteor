import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meteor/navigator/page_life_cycle.dart';

class MeteorNavigatorObserver extends NavigatorObserver {
  // 创建一个私有的静态实例
  static final MeteorNavigatorObserver _instance = MeteorNavigatorObserver._internal();

  // 私有的构造函数
  MeteorNavigatorObserver._internal() {
    methodChannel.setMessageHandler(
      (message) async {
        if (message is Map) {
          final String? event = message['event'] ?? '';
          // final String route = message['route'] ?? 'unknown';
          // final String previousRoute = message['previousRoute'] ?? 'unknown';
          // print('==== page event:$event, route:$route, previousRoute:$previousRoute');
          switch (event) {
            // case 'didPush':
            //   PageLifeCycleManager.instance.notifyDidPop(route, previousRoute);
            // case 'didPop':
            //   PageLifeCycleManager.instance.notifyDidPop(route, previousRoute);
            // case 'didReplace':
            //   PageLifeCycleManager.instance.notifyDidReplace(route, previousRoute);
            // case 'didRemove':
            //   PageLifeCycleManager.instance.notifyDidRemove(route, previousRoute);
            case 'onContainerVisible':
              PageLifeCycleManager.instance.notifyOnContainerVisible();
            case 'onContainerInvisible':
              PageLifeCycleManager.instance.notifyOnContainerInvisible();
          }
        }
      },
    );
  }

  // 提供一个工厂构造函数，返回同一实例
  factory MeteorNavigatorObserver() {
    return _instance;
  }
  // final NavigatorState? navigator = Navigator.of(MyApp.mainKey.currentContext!);

  final BasicMessageChannel methodChannel =
      const BasicMessageChannel('itbox.meteor.navigatorObserver', StandardMessageCodec());

  final List<Route<dynamic>> _routeStack = [];

  List<Route<dynamic>> get routeStack => List.unmodifiable(_routeStack);
  List<String> get routeNameStack {
    List<String> names = <String>[];
    for (var element in routeStack) {
      names.add(element.settings.name ?? '');
    }
    return names;
  }

  Route<dynamic>? get topRoute => _routeStack.isNotEmpty ? _routeStack.last : null;
  Route<dynamic>? get rootRoute => _routeStack.isNotEmpty ? _routeStack.first : null;
  String? get topRouteName => topRoute?.settings.name;
  String? get rootRouteName => rootRoute?.settings.name;

  // static bool? get isRootRoute => _routeStack.isNotEmpty ? _routeStack.first : null;

  bool isRootRoute(String routeName) {
    return routeName == rootRouteName;
  }

  bool routeExists(String routeName) {
    return _routeStack.any(
      (route) => route.settings.name == routeName,
    );
  }

  bool isCurrentRoot() {
    return topRouteName != null && rootRouteName != null && rootRouteName == topRouteName;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routeStack.add(route);
    super.didPush(route, previousRoute);
    sendNavigatorStackChanged();
    PageLifeCycleManager.instance.notifyDidPush(
      route.settings.name ?? 'unknownFlutterRoute',
      previousRoute?.settings.name ?? 'unknownFlutterRoute',
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routeStack.remove(route);
    super.didPop(route, previousRoute);
    sendNavigatorStackChanged();
    PageLifeCycleManager.instance.notifyDidPop(
      route.settings.name ?? 'unknownFlutterRoute',
      previousRoute?.settings.name ?? 'unknownFlutterRoute',
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routeStack.remove(route);
    super.didRemove(route, previousRoute);
    sendNavigatorStackChanged();
    PageLifeCycleManager.instance.notifyDidRemove(
      route.settings.name ?? 'unknownFlutterRoute',
      previousRoute?.settings.name ?? 'unknownFlutterRoute',
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute == null) {
      return;
    }
    final index = _routeStack.indexOf(oldRoute!);
    if (index != -1) {
      _routeStack[index] = newRoute!;
    }
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    sendNavigatorStackChanged();
    PageLifeCycleManager.instance.notifyDidReplace(
      newRoute?.settings.name ?? 'unknownFlutterRoute',
      oldRoute.settings.name ?? 'unknownFlutterRoute',
    );
  }

  void sendNavigatorStackChanged() {
    if (Platform.isIOS) {
      /// iOS需要监听flutter端是否可以继续pop以便控制popGesture手势
      methodChannel.send({"event": "canPop", "data": navigator?.canPop() ?? false});
    }
  }
}
