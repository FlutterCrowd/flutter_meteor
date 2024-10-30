# flutter_meteor

## Overview
`flutter_meteor` is a multi-engine hybrid stack management framework designed for seamless page navigation and state synchronization between native and Flutter. 
Its core features include:
 - **Navigator Module**
 - **Shared Cache**
 - **Event Bus**
 - **Shared State**

This plugin simplifies page navigation, communication, and state management in multi-engine environments. For more information, please refer to the Multi-Engine Plugin Details.

## Integration Steps

### 1. Install the Plugin

Add the following configuration to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_meteor: ^1.0.4
```
### 2. Initialize the Plugin
Initialize in the default main function of your Flutter application:

```
final GlobalKey<NavigatorState> rootKey = GlobalKey<NavigatorState>();

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the navigator
  MeteorNavigator.init(rootKey: rootKey);

  // Register global instances
  await MeteorSharedObjectManager.registerGlobalInstances([
    GlobalUserStateManager(),
    GlobalAppStateManager(),
  ]);

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
```
### 3. Custom Entry Function
If a custom entry function is needed, use the following code:

```
@pragma("vm:entry-point")
void childEntry(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await MeteorSharedObjectManager.registerGlobalInstances([
    GlobalUserStateManager(),
    GlobalAppStateManager(),
  ]);

  MeteorNavigator.init(rootKey: rootKey);

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
```
### 4. Configure MaterialApp
Set the global navigatorKey and add MeteorNavigator.navigatorObserver in the MaterialApp:

```
MaterialApp(
  onGenerateRoute: AppRouterCenter.generateRoute,
  navigatorKey: rootKey,
  navigatorObservers: [
    MeteorNavigator.navigatorObserver,
    AppRouterCenter.routeObserver,
  ],
  theme: ThemeData.light(),
  initialRoute: initialRoute ?? 'homePage',
  debugShowCheckedModeBanner: false,
  onGenerateInitialRoutes: (String initialRoute) {
    var route = AppRouterCenter.generateRoute(
      RouteSettings(name: initialRoute, arguments: widget.routeArguments),
    );
    route ??= AppRouterCenter.generateRoute(
      const RouteSettings(name: "homePage", arguments: null),
    );
    return [route!];
  },
)
```
## Usage Examples
### 1. Navigator
**API Example**

```
Future<T?> pushNamed<T extends Object?>(
  String routeName, {
  PageType pageType = PageType.flutter,
  bool isOpaque = true,
  bool animated = true,
  bool present = false,
  Map<String, dynamic>? arguments,
});
```
**Usage Example**
```
// Navigate to the page shareStatePage1
MeteorNavigator.pushNamed("shareStatePage1");

MeteorNavigator.pop();
```
### 2. Event Bus
**API Example**

```
static void addListener({
  required String eventName,
  String? listenerId,
  required MeteorEventBusListener listener,
});
```
**Usage Example**

```
// Register an event
MeteorEventBus.addListener(
  eventName: 'eventName',
  listener: (data) {
    if (mounted) {
      setState(() {
        _eventData2 = data;
      });
    }
  },
);

// Send an event
MeteorEventBus.commit(eventName: 'eventName', data: 'This is a string');
```
### 3. Shared Cache
**API Example**
```
static Future<void> setString(String key, String? value);
static Future<String?> getString(String key);
```
**Usage Example**
```
// Store a boolean value
SharedMemoryCache.setBool('boolKey', true);

bool? value = await SharedMemoryCache.getBool('boolKey');
print("Retrieved:---> $value");
```
### 4. Shared State
**API Example**
```
class GlobalStateService extends MeteorValueProvider<String> {}

class MeteorSharedObjectProvider<T extends MeteorSharedObject> with ChangeNotifier {
  // Implementation details...
}
```
**Usage Example**
```
Widget build(BuildContext context) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => GlobalStateService()),
      ChangeNotifierProvider(
        create: (_) => MeteorSharedObjectProvider<UserInfo>(model: UserInfo()),
      ),
    ],
    child: MaterialApp(
      onGenerateRoute: AppRouterCenter.generateRoute,
      navigatorKey: rootKey,
      navigatorObservers: [
        MeteorNavigator.navigatorObserver,
        AppRouterCenter.routeObserver,
      ],
      theme: ThemeData.light(),
      initialRoute: initialRoute,
      debugShowCheckedModeBanner: false,
      onGenerateInitialRoutes: (String initialRoute) {
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
```

License
MIT License

Copyright (c) 2024 [Your Name or Your Organization]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
