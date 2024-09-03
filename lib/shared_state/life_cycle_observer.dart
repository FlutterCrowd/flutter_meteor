import 'package:flutter/widgets.dart';
import 'package:flutter_meteor/flutter_meteor.dart';

class MeteorLifecycleObserver with WidgetsBindingObserver {
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
    for (var element in MeteorSharedObjectManager.allInstances) {
      await element.saveToSharedCache();
    }
  }

  void onForeground() async {
    for (var element in MeteorSharedObjectManager.allInstances) {
      await element.setupFromSharedCache();
    }
  }
}
