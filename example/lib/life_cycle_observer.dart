import 'package:flutter/widgets.dart';
import 'package:flutter_meteor/flutter_meteor.dart';

class AppLifecycleObserver with WidgetsBindingObserver {
  static bool _isForeground = true;

  static bool get isForeground => _isForeground;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      /// 应用程序进入前台
      onForeground();
    } else if (state == AppLifecycleState.paused) {
      /// 应用程序进入后台
      onBackground();
    }
    print('didChangeAppLifecycleState: $state');
  }

  void onBackground() async {
    _isForeground = false;
  }

  void onForeground() async {
    _isForeground = true;
  }

  @override
  Future<bool> didPopRoute() async {
    print('didPopRoute: ${await MeteorNavigator.topRouteName()}');
    return super.didPopRoute();
  }

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) async {
    print('didPushRouteInformation: ${await MeteorNavigator.topRouteName()}');
    print('didPushRouteInformation routeInformation: $routeInformation');
    return super.didPushRouteInformation(routeInformation);
  }
}
