import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'hz_router_plugin_method_channel.dart';

abstract class HzRouterPluginPlatform extends PlatformInterface {
  /// Constructs a HzRouterPluginPlatform.
  HzRouterPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static HzRouterPluginPlatform _instance = HzRouterPluginMethodChannel();

  /// The default instance of [HzRouterPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelHzRouterPlugin].
  static HzRouterPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HzRouterPluginPlatform] when
  /// they register themselves.
  static set instance(HzRouterPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  static const String hzPushNamedMethod = 'pushNamed';
  static const String hzPushReplacementNamedMethod = 'pushReplacementNamed';
  static const String hzPushNamedAndRemoveUntilMethod = 'pushNamedAndRemoveUntil';
  static const String hzPopMethod = 'pop';
  static const String hzPopUntilMethod = 'popUntil';
  static const String hzPopToRootMethod = 'popToRoot';
  static const String hzDismissMethod = 'dismiss';

  void setCustomMethodCallHandler(
      {Function(String method, dynamic arguments)? customMethodCallHandler});

  Future<T?> invokeMethod<T extends Object?>(
      {required String method, Map<String, dynamic>? arguments});
}
