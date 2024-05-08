import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'hz_router_plugin_method_channel.dart';

abstract class HzRouterPluginPlatform extends PlatformInterface {
  /// Constructs a HzRouterPluginPlatform.
  HzRouterPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static HzRouterPluginPlatform _instance = MethodChannelHzRouterPlugin();

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

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  /// 原生返回上一级
  Future<Map<String, dynamic>?> pop({Map<String, dynamic>? arguments});

  /// 原生返回根试图
  Future<Map<String, dynamic>?> popToRoot({Map<String, dynamic>? arguments});

  /// 原生push到新的页面
  Future<Map<String, dynamic>?> push({required String routerName, Map<String, dynamic>? arguments});
}
