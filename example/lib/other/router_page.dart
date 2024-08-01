import 'package:flutter/material.dart';
import 'package:hz_router_plugin_example/router/router_center.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RouteAwareWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SecondPage()),
              );
            },
            child: Text('Go to Second Page'),
          ),
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RouteAwareWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Second Page'),
        ),
        body: Center(
          child: Text('Second Page'),
        ),
      ),
    );
  }
}

class RouteAwareWidget extends StatelessWidget {
  const RouteAwareWidget({super.key, required this.child, this.canPop = true});

  final Widget child;
  final bool canPop;
  @override
  Widget build(BuildContext context) {
    // 订阅路由观察者
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ModalRoute? modalRoute = ModalRoute.of(context);
      if (modalRoute is PageRoute) {
        RouterCenter.routeObserver.subscribe(RouteAwareSingleton.instance, modalRoute);
      }
    });

    // 返回一个 WillPopScope 以捕获页面移除时的事件
    return PopScope(
      key: key != null ? Key(key.toString()) : key,
      canPop: canPop,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          final ModalRoute? modalRoute = ModalRoute.of(context);
          if (modalRoute is PageRoute) {
            RouterCenter.routeObserver.unsubscribe(RouteAwareSingleton.instance);
          }
        }
      },
      child: child,
    );
  }
}

/// demo
class RouteAwareSingleton with RouteAware {
  static final RouteAwareSingleton instance = RouteAwareSingleton._internal();

  RouteAwareSingleton._internal();

  @override
  void didPush() {
    print('RouteAwareSingleton: didPush');
  }

  @override
  void didPopNext() {
    print('RouteAwareSingleton: didPopNext');
  }

  @override
  void didPushNext() {
    print('RouteAwareSingleton: didPushNext');
  }

  @override
  void didPop() {
    print('RouteAwareSingleton: didPop');
  }
}
