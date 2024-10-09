import 'package:flutter/services.dart';
import 'package:hz_tools/hz_tools.dart';

import '../impl/flutter.dart';
import 'method.dart';

class MeteorMethodChannel {
  static final MeteorFlutterNavigator _flutterNavigator = MeteorFlutterNavigator();
  MeteorMethodChannel() {
    methodChannel.setMethodCallHandler(
      (call) async {
        // HzLog.t(
        // 'Meteor 原生调用flutter isMain:${MeteorEngine.isMain}  method:${call.method}, methodArguments:${call.arguments}');
        Map<String, dynamic> arguments = <String, dynamic>{};
        if (call.arguments is Map) {
          Map res = call.arguments;
          res.forEach((key, value) {
            arguments[key.toString()] = value;
          });
        } else {
          arguments["arguments"] = call.arguments;
        }
        if (call.method == FMNavigatorMethod.popMethod) {
          return await flutterPop(arguments: arguments);
        } else if (call.method == FMNavigatorMethod.popUntilMethod) {
          return await flutterPopUntil(arguments: arguments);
        } else if (call.method == FMNavigatorMethod.popToRootMethod) {
          return await flutterPopRoRoot(arguments: arguments);
        } else if (call.method == FMNavigatorMethod.pushNamedMethod) {
          return await flutterPushNamed(arguments: arguments);
        } else if (call.method == FMNavigatorMethod.pushReplacementNamedMethod) {
          return await flutterPushAndReplace(arguments: arguments);
        } else if (call.method == FMNavigatorMethod.pushNamedAndRemoveUntilMethod) {
          return await flutterPushAndRemoveUntil(arguments: arguments);
        } else if (call.method == FMNavigatorMethod.pushNamedAndRemoveUntilRootMethod) {
          return await flutterPushAndRemoveUntilRoot(arguments: arguments);
        } else if (call.method == FMNavigatorMethod.routeExists) {
          String routeName = arguments['routeName'] ?? '';
          bool ret = await _flutterNavigator.routeExists(routeName);
          return ret;
        } else if (call.method == FMNavigatorMethod.isRoot) {
          String routeName = arguments['routeName'] ?? '';
          bool ret = await _flutterNavigator.isRoot(routeName);
          return ret;
        } else if (call.method == FMNavigatorMethod.rootRouteName) {
          String? ret = await _flutterNavigator.rootRouteName();
          return ret;
        } else if (call.method == FMNavigatorMethod.topRouteName) {
          String? ret = await _flutterNavigator.topRouteName();
          return ret;
        } else if (call.method == FMNavigatorMethod.routeNameStack) {
          List<String> routeNameStack = await _flutterNavigator.routeNameStack();
          return routeNameStack;
        } else {
          return null;
        }
      },
    );
  }

  /// The method channel used to interact with the native platform.
  final MethodChannel methodChannel = const MethodChannel('itbox.meteor.navigatorChannel');

  /// ***********Native to flutter*************/
  Future<dynamic> flutterPop({Map<String, dynamic>? arguments}) async {
    return _flutterNavigator.pop(null);
  }

  Future<dynamic> flutterPopUntil({Map<String, dynamic>? arguments}) async {
    String? routeName = arguments?["routeName"];
    if (routeName != null) {
      bool isFarthest = false;
      if (arguments?['isFarthest'] != null && arguments?['isFarthest'] is bool) {
        isFarthest = arguments!['isFarthest'];
      }
      return _flutterNavigator.popUntil(routeName, isFarthest: isFarthest);
    } else {
      return _flutterNavigator.pop();
    }
  }

  Future<dynamic> flutterPopRoRoot({Map<String, dynamic>? arguments}) async {
    HzLog.i('Channel flutterPopRoRoot arguments: $arguments');
    return _flutterNavigator.popToFirstRoute();
  }

  Future<dynamic> flutterPushNamed({Map<String, dynamic>? arguments}) async {
    // Map<String, dynamic> arg = {};
    // if (arguments != null) {
    //   arg.addAll(arguments);
    // }
    String? routeName = arguments?["routeName"];
    HzLog.t('Channel flutterPushNamed arguments: $arguments');
    if (routeName != null) {
      return await _flutterNavigator.pushNamed(routeName);
    }
  }

  Future<dynamic> flutterPushAndReplace({Map<String, dynamic>? arguments}) async {
    // Map<String, dynamic> arg = {};
    // if (arguments != null) {
    //   arg.addAll(arguments);
    // }
    String? routeName = arguments?["routeName"];
    HzLog.t('Channel flutterPushNamed arguments: $arguments');
    if (routeName != null) {
      return await _flutterNavigator.pushReplacementNamed(routeName);
    }
  }

  Future<dynamic> flutterPushAndRemoveUntil({Map<String, dynamic>? arguments}) async {
    // Map<String, dynamic> arg = {};
    // if (arguments != null) {
    //   arg.addAll(arguments);
    // }
    String? routeName = arguments?["routeName"];
    String? untilRouteName = arguments?["untilRouteName"];
    HzLog.t('Channel flutterPushNamed arguments: $arguments');
    if (routeName != null) {
      if (untilRouteName != null) {
        return await _flutterNavigator.pushNamedAndRemoveUntil(routeName, untilRouteName);
      } else {
        return await _flutterNavigator.pushNamed(routeName);
      }
    } else {
      return null;
    }
  }

  Future<dynamic> flutterPushAndRemoveUntilRoot({Map<String, dynamic>? arguments}) async {
    // Map<String, dynamic> arg = {};
    // if (arguments != null) {
    //   arg.addAll(arguments);
    // }
    String? routeName = arguments?["routeName"];
    if (routeName != null) {
      return await _flutterNavigator.pushNamedAndRemoveUntilRoot(routeName);
    } else {
      return null;
    }
  }
}