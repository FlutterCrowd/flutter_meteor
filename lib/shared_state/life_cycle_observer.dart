import 'package:flutter/widgets.dart';
import 'package:flutter_meteor/flutter_meteor.dart';

class MeteorLifecycleObserver with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      /// 应用程序进入前台
      setupSharedObject();
    } else {
      /// 应用程序进入后台
      saveSharedObject();
    }
    print('didChangeAppLifecycleState: $state, engine: ${WidgetsBinding.instance.hashCode}');
  }

  void saveSharedObject() async {
    for (var element in MeteorSharedObjectManager.allInstances) {
      await element.saveToSharedCache();
    }
  }

  void setupSharedObject() async {
    for (var element in MeteorSharedObjectManager.allInstances) {
      await element.setupFromSharedCache();
    }
  }
}
