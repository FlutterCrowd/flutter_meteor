abstract class PageLifeObserver {
  void didPush(String routeName, String? preRouteName);

  void didPop(String routeName, String? preRouteName);

  void didRemove(String routeName, String? preRouteName);

  void didReplace({String? routeName, String? preRouteName});

  /// 原生flutter 容器(ios-FlutterViewController, android-FlutterActivity)显示
  void onContainerVisible();

  /// 原生flutter 容器(ios-FlutterViewController, android-FlutterActivity)隐藏
  void onContainerInvisible();
}

class PageLifeCycleManager {
  static final PageLifeCycleManager _instance = PageLifeCycleManager._internal();
  factory PageLifeCycleManager() => _instance;

  static PageLifeCycleManager get instance => _instance;

  PageLifeCycleManager._internal();
  final List<PageLifeObserver> _observers = [];
  void addObserver(PageLifeObserver observer) {
    _observers.add(observer);
  }

  void removeObserver(PageLifeObserver observer) {
    _observers.remove(observer);
  }

  void notifyDidPush(String routeName, String? preRouteName) {
    print('==== notifyDidPush routeName:$routeName, preRouteName:$preRouteName');
    for (var observer in _observers) {
      observer.didPush(routeName, preRouteName);
    }
  }

  void notifyDidPop(String routeName, String? preRouteName) {
    print('==== notifyDidPop routeName:$routeName, preRouteName:$preRouteName');

    for (var observer in _observers) {
      observer.didPop(routeName, preRouteName);
    }
  }

  void notifyDidRemove(String routeName, String? preRouteName) {
    for (var observer in _observers) {
      observer.didRemove(routeName, preRouteName);
    }
  }

  void notifyDidReplace(String routeName, String? preRouteName) {
    for (var observer in _observers) {
      observer.didReplace(routeName: routeName, preRouteName: preRouteName);
    }
  }

  void notifyOnContainerVisible() {
    for (var observer in _observers) {
      observer.onContainerVisible();
    }
  }

  void notifyOnContainerInvisible() {
    for (var observer in _observers) {
      observer.onContainerInvisible();
    }
  }
}
