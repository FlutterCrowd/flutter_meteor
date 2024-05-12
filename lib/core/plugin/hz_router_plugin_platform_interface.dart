import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'hz_router_plugin_method_channel.dart';

abstract class HzRouterPluginPlatform  {
  static const String hzPushNamedMethod = 'pushNamed';
  static const String hzPushReplacementNamedMethod = 'pushReplacementNamed';
  static const String hzPushNamedAndRemoveUntilMethod = 'pushNamedAndRemoveUntil';
  static const String hzPopMethod = 'pop';
  static const String hzPopUntilMethod = 'popUntil';
  static const String hzPopToRootMethod = 'popToRoot';
  static const String hzDismissMethod = 'dismiss';
}
