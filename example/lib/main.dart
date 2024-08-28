import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meteor/flutter_meteor.dart';
import 'package:hz_router_plugin_example/router/router_center.dart';
import 'package:hz_router_plugin_example/shared_state/global_singleton_object.dart';
import 'package:provider/provider.dart';

import 'life_cycle_observer.dart';
import 'shared_state/multi_engine_state.dart';

final GlobalKey<NavigatorState> rootKey = GlobalKey<NavigatorState>();

class UserInfo extends MeteorSharedObject {
  UserInfo({
    this.name = 'name',
    this.phone = '18501125114',
    this.gender = 1,
  }) : super(initialFromCache: false);
  String? name = 'name';
  String? phone = '18501125114';
  int? gender = 1;

  @override
  void setupFromJson(Map<String, dynamic>? json) {
    if (json != null) {
      name = json['name'];
      gender = json['gender'];
      phone = json['phone'];
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'gender': gender,
      'phone': phone,
    };
  }

  UserInfo copy(Map<String, dynamic> json) {
    // TODO: implement copyWithJson
    // Map<String, dynamic> modelJson = super.copyWithJson(json);
    UserInfo userInfo = UserInfo();
    // userInfo.setupFromJson(modelJson);
    return userInfo;
  }
}

void main(List<String> args) async {
  if (kDebugMode) {
    print('这是传递过来的参数：$args');
  }
  WidgetsFlutterBinding.ensureInitialized();
  // await GlobalUserStateManager().setupFromSharedCache();
  // await MeteorSharedObject.create(() => GlobalUserStateManager());

  await MeteorSharedObjectManager.registerGlobalInstances([
    GlobalUserStateManager(),
    GlobalAppStateManager(),
  ]);

  WidgetsBinding.instance.addObserver(AppLifecycleObserver());
  EntryArguments arguments = MeteorEngine.parseEntryArgs(args);
  String? initialRoute = arguments.initialRoute;
  Map<String, dynamic>? routeArguments = arguments.routeArguments;
  runApp(
    MyApp(
      initialRoute: initialRoute,
      routeArguments: routeArguments,
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
      MyApp(
        initialRoute: initialRoute,
        routeArguments: routeArguments,
      ),
    );
  } else {
    runApp(
      const MyApp(),
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
    initialRoute = widget.initialRoute ?? 'homePage';
    AppRouterCenter.setup();
    MeteorNavigator.init(rootKey: rootKey);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GlobalStateService()),
        ChangeNotifierProvider(create: (_) => MeteorStringProvider()),
        ChangeNotifierProvider(create: (_) => MeteorBoolProvider()),
        ChangeNotifierProvider(create: (_) => MeteorIntProvider()),
        ChangeNotifierProvider(create: (_) => MeteorDoubleProvider()),
        ChangeNotifierProvider(create: (_) => MeteorListProvider()),
        ChangeNotifierProvider(create: (_) => MeteorMapProvider()),
        ChangeNotifierProvider(create: (_) => MeteorBytesProvider()),
        ChangeNotifierProvider(create: (_) => MeteorSharedProvider<UserInfo>(model: UserInfo())),
      ],
      child: MaterialApp(
        onGenerateRoute: AppRouterCenter.generateRoute,
        navigatorKey: rootKey,
        navigatorObservers: [
          MeteorNavigator.navigatorObserver,
          AppRouterCenter.routeObserver,
        ],
        // initialRoute: "home",
        theme: ThemeData.light(),
        initialRoute: initialRoute,
        debugShowCheckedModeBanner: false,
        onGenerateInitialRoutes: (String initialRoute) {
          if (kDebugMode) {
            print('initialRoute: $initialRoute');
          }
          // MeteorNavigator.rootRoute = initialRoute;
          var route = AppRouterCenter.generateRoute(
            RouteSettings(name: initialRoute, arguments: widget.routeArguments),
          );
          route ??= AppRouterCenter.generateRoute(
            const RouteSettings(name: "homePage", arguments: null),
          );
          return [route!];
        },
      ),
    );
  }
}
