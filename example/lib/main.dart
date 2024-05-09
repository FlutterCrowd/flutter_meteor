import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hz_router/core/hz_navigator.dart';
import 'package:hz_router/core/hz_router_manager.dart';
import 'package:hz_router/plugin/hz_router_plugin.dart';

import 'home_page.dart';
import 'mine_page.dart';
import 'multi_engin_page.dart';
import 'multi_engin_page2.dart';

void main() {
  runApp(const MyApp());
}

@pragma("vm:entry-point")
void childEntry(List<String> arg) {
  print('这是传递过来的参数：$arg');
  // runApp(const MyApp());
  if (arg.isNotEmpty) {
    String routerName = arg.first;
    Map<String, dynamic> arguments = jsonDecode(arg.last);
    runApp(MyApp(
      routeName: routerName,
      routeArguments: arguments,
    ));
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatefulWidget {
  final String? routeName;
  final Map<String, dynamic>? routeArguments;
  const MyApp({super.key, this.routeName, this.routeArguments});

  @override
  State<MyApp> createState() => _MyAppState();
}

Map<String, WidgetBuilder> routes = {
  "/": (context) => Column(
        children: [
          Expanded(child: Container()),
          GestureDetector(
            onTap: () {
              HzNavigator.pushNamed(context, routeName: "home");
            },
            child: const Center(
              child: Text('首页'),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (HzNavigator.isCurrentRouteRoot(context)) {
                HzRouterPlugin().pop();
              } else {
                HzNavigator.pop(context);
              }
            },
            child: const Center(
              child: Text('返回上一页'),
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
  "home": (context) => const HomePage(),
  "mine": (context) => MinePage(),
  "multi_engin": (context) => MultiEnginPage(),
  "multi_engin2": (context) => MultiEnginPage2()
};

class _MyAppState extends State<MyApp> {
  late String routeName;

  @override
  void initState() {
    super.initState();
    routeName = widget.routeName ?? '/';
    HzNavigator.naviKey = GlobalKey<NavigatorState>();
    HzRouterManager.insertRouters(routes);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: HzRouterManager.generateRoute,
      navigatorKey: HzNavigator.naviKey,
      // initialRoute: routeName,
      onGenerateInitialRoutes: (String initialRoute) {
        // const url = "/mine?key=value";
        WidgetBuilder builder = routes[initialRoute] ?? routes['/']!;
        // builder?.call(context);
        RouteSettings settings =
            RouteSettings(name: initialRoute, arguments: widget.routeArguments);
        final Route<dynamic> route = MaterialPageRoute(
          builder: builder,
          settings: settings,
        );
        HzNavigator.root = initialRoute;

        /// 记录根路由，用于pop判断
        HzNavigator.routePage = route;
        // HzRouterManager.routeInfo[HzNavigator.root] = builder;
        return [route];
      },
    );
  }
}
