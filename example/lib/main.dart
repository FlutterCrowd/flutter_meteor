import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meteor/flutter_meteor.dart';
import 'package:hz_router_plugin_example/router/router_center.dart';
import 'package:provider/provider.dart';

import 'life_cycle_observer.dart';
import 'multi_engine/multi_engine_state.dart';

final GlobalKey<NavigatorState> rootKey = GlobalKey<NavigatorState>();
void main(List<String> args) {
  // WidgetsFlutterBinding.ensureInitialized();
  // WidgetsBinding.instance.addObserver(AppLifecycleObserver());
  //
  // runApp(
  //   MultiProvider(
  //     providers: [
  //       ChangeNotifierProvider(create: (_) => GlobalStateService()),
  //     ],
  //     child: const MyApp(),
  //   ),
  // );

  if (kDebugMode) {
    print('这是传递过来的参数：$args');
  }
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding.instance.addObserver(AppLifecycleObserver());
  EntryArguments arguments = MeteorEngine.parseEntryArgs(args);
  String? initialRoute = arguments.initialRoute;
  Map<String, dynamic>? routeArguments = arguments.routeArguments;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GlobalStateService()),
      ],
      child: MyApp(
        initialRoute: initialRoute,
        routeArguments: routeArguments,
      ),
    ),
  );
}

@pragma("vm:entry-point")
void childEntry(List<String> args) {
  if (kDebugMode) {
    print('这是传递过来的参数：$args');
  }
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding.instance.addObserver(AppLifecycleObserver());
  if (args.isNotEmpty) {
    EntryArguments arguments = MeteorEngine.parseEntryArgs(args);
    String? initialRoute = arguments.initialRoute;
    Map<String, dynamic>? routeArguments = arguments.routeArguments;
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => GlobalStateService()),
        ],
        child: MyApp(
          initialRoute: initialRoute,
          routeArguments: routeArguments,
        ),
      ),
    );
  } else {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => GlobalStateService()),
        ],
        child: const MyApp(),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  // static GlobalKey<NavigatorState> mainKey = GlobalKey<NavigatorState>();
  final String? initialRoute;
  final Map<String, dynamic>? routeArguments;
  const MyApp({super.key, this.initialRoute, this.routeArguments});

  @override
  State<MyApp> createState() => _MyAppState();
}

// Map<String, WidgetBuilder> _routes = {
//   "rootPage": (context) => const RootPage(),
//   "homePage": (context) => const HomePage(),
//   "minePage": (context) => MinePage(),
//   "multiEnginePage": (context) => MultiEnginPage(),
//   "multiEnginePage2": (context) => const MultiEnginPage2(),
//   "popWindowPage": (context) => const PopWindowPage(),
//   "backPage": (context) => BackPage(),
// };

// Route<dynamic>? _generateRoute(RouteSettings settings) {
//   final String? name = settings.name;
//   final Widget Function(BuildContext)? pageRouteBuilder = _routes[name];
//   if (pageRouteBuilder != null) {
//     if (name == 'popWindowPage') {
//       return PageRouteBuilder(
//         opaque: false,
//         pageBuilder: (context, _, __) => pageRouteBuilder(context),
//         settings: settings,
//       );
//     }
//     final Route<dynamic> route = MaterialPageRoute(
//       builder: pageRouteBuilder,
//       settings: settings,
//     );
//     return route;
//   } else {
//     return null;
//   }
// }

class _MyAppState extends State<MyApp> {
  late String initialRoute;

  @override
  void initState() {
    super.initState();
    initialRoute = widget.initialRoute ?? 'rootPage';
    RouterCenter.setup();
    MeteorNavigator.init(rootKey: rootKey);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: RouterCenter.generateRoute,

      navigatorKey: rootKey,
      navigatorObservers: [
        MeteorNavigator.navigatorObserver,
        RouterCenter.routeObserver,
      ],
      // initialRoute: "home",
      theme: ThemeData.light(),
      // home: HomePage(),
      // home: const RootPage(
      //   key: Key('RootPage'),
      // ),
      initialRoute: initialRoute,
      debugShowCheckedModeBanner: false,
      onGenerateInitialRoutes: (String initialRoute) {
        if (kDebugMode) {
          print('initialRoute: $initialRoute');
        }
        // MeteorNavigator.rootRoute = initialRoute;
        var route = RouterCenter.generateRoute(
          RouteSettings(name: initialRoute, arguments: widget.routeArguments),
        );
        route ??= RouterCenter.generateRoute(
          const RouteSettings(name: "homePage", arguments: null),
        );
        return [route!];
      },
    );
  }
}
