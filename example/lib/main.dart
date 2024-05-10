import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hz_router/hz_router.dart';

import 'home_page.dart';
import 'mine_page.dart';
import 'multi_engin_page.dart';
import 'multi_engin_page2.dart';
import 'root_page.dart';

void main() {
  runApp(const MyApp());
}

// 这里的entry-point能否放到插件里面？？？
@pragma("vm:entry-point")
void childEntry(List<String?> arg) {
  print('这是传递过来的参数：$arg');
  // runApp(const MyApp());
  if (arg.isNotEmpty) {
    String? routeName = arg.first;
    String routeArgs = arg.last ?? '';
    Map<String, dynamic>? arguments = routeArgs.isNotEmpty ? jsonDecode(arg.last!) : null;
    runApp(MyApp(
      routeName: routeName,
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
  "/": (context) => const RootPage(),
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
      initialRoute: routeName,
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
