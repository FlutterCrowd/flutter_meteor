import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meteor/flutter_meteor.dart';
import 'package:hz_router_plugin_example/router/router_center.dart';
import 'package:hz_router_plugin_example/shared_state/global_singleton_object.dart';
import 'package:provider/provider.dart';

import 'life_cycle_observer.dart';
import 'shared_state/multi_engine_state.dart';

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

final GlobalKey<NavigatorState> rootKey = GlobalKey<NavigatorState>();

void main(List<String> args) async {
  if (kDebugMode) {
    print('这是初始化引擎传递过来的参数：$args');
  }
  // 确保 Flutter 的核心引擎和 Widgets 系统已经初始化。
  // 在应用启动时执行与平台相关的操作或在访问平台通道时，
  // 你需要确保 Flutter 的引擎已经启动且 Widgets 系统已经完全初始化。
  // 否则，可能会出现未初始化的异常。
  WidgetsFlutterBinding.ensureInitialized();

  // 注册共享对象，一些需要跨引擎共享的对象可以在这里注册
  // 确保这些对象在润runApp的时候能访问到
  await MeteorSharedObjectManager.registerGlobalInstances([
    GlobalUserStateManager(),
    GlobalAppStateManager(),
  ]);

  WidgetsBinding.instance.addObserver(AppLifecycleObserver());

  // 初始化导航器，用于flutter页面导航
  MeteorNavigator.init(rootKey: rootKey);

  // 解析原生传递过来的初始化参数
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
void childEntry(List<String> args) async {
  if (kDebugMode) {
    print('这是初始化引擎传递过来的参数：$args');
  }
  // 确保 Flutter 的核心引擎和 Widgets 系统已经初始化。
  // 在应用启动时执行与平台相关的操作或在访问平台通道时，
  // 你需要确保 Flutter 的引擎已经启动且 Widgets 系统已经完全初始化。
  // 否则，可能会出现未初始化的异常。
  WidgetsFlutterBinding.ensureInitialized();

  // 注册共享对象，一些需要跨引擎共享的对象可以在这里注册
  // 确保这些对象在润runApp的时候能访问到
  await MeteorSharedObjectManager.registerGlobalInstances([
    GlobalUserStateManager(),
    GlobalAppStateManager(),
  ]);

  WidgetsBinding.instance.addObserver(AppLifecycleObserver());

  // 初始化导航器
  // 初始化导航器，用于flutter页面导航
  MeteorNavigator.init(rootKey: rootKey);

  // 解析原生传递过来的初始化参数
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
        ChangeNotifierProvider(
            create: (_) => MeteorSharedObjectProvider<UserInfo>(model: UserInfo())),
      ],
      child: MaterialApp(
        onGenerateRoute: AppRouterCenter.generateRoute,
        navigatorKey: rootKey, // 1、指定navigatorKey
        navigatorObservers: [
          MeteorNavigator.navigatorObserver, // 2、设置MeteorNavigator的Observer
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
          // 3、动态解析初始路由，默认是首页
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
