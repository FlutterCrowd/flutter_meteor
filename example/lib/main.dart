import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hz_router/hz_router.dart';

import 'home_page.dart';
import 'mine_page.dart';
import 'multi_engin_page.dart';
import 'multi_engin_page2.dart';
import 'pop_window.dart';
import 'root_page.dart';

void main() {
  runApp(const MyApp());
}

@pragma("vm:entry-point")
void childEntry(List<String> args) {
  print('这是传递过来的参数：$args');

  if (args.isNotEmpty) {
    final json = jsonDecode(args.first);
    String routeName = json['initialRoute'];
    Map<String, dynamic>? routeArguments = json['routeArguments'];
    runApp(MyApp(
      routeName: routeName,
      routeArguments: routeArguments,
    ));
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatefulWidget {
  // static GlobalKey<NavigatorState> mainKey = GlobalKey<NavigatorState>();
  final String? routeName;
  final Map<String, dynamic>? routeArguments;
  const MyApp({super.key, this.routeName, this.routeArguments});

  @override
  State<MyApp> createState() => _MyAppState();
}

Map<String, WidgetBuilder> _routes = {
  "/": (context) => const RootPage(),
  "home": (context) => const HomePage(),
  "mine": (context) => MinePage(),
  "multi_engin": (context) => MultiEnginPage(),
  "multi_engin2": (context) => MultiEnginPage2(),
  "popWindow": (context) => const PopWindowPage()
};

Route<dynamic>? _generateRoute(RouteSettings settings) {
  final String? name = settings.name;
  final Widget Function(BuildContext)? pageRouteBuilder = _routes[name];
  if (pageRouteBuilder != null) {
    if (name == 'popWindow') {
      return PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, _, __) => pageRouteBuilder(context),
        settings: settings,
      );
    }
    final Route<dynamic> route = MaterialPageRoute(
      builder: pageRouteBuilder,
      settings: settings,
    );
    return route;
  } else {
    return null;
  }
}

class _MyAppState extends State<MyApp> {
  late String routeName;
  final GlobalKey<NavigatorState> rootKey = GlobalKey<NavigatorState>();
  @override
  void initState() {
    super.initState();
    routeName = widget.routeName ?? '/';
    HzNavigator.init(rootKey: rootKey);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: _generateRoute,
      navigatorKey: rootKey,
      initialRoute: "/",
      onGenerateInitialRoutes: (String initialRoute) {
        print('initialRoute: $initialRoute');
        HzNavigator.rootRoute = initialRoute;
        final route = _generateRoute(
          RouteSettings(name: initialRoute, arguments: widget.routeArguments),
        );
        return [route!];
      },
    );
  }
}
