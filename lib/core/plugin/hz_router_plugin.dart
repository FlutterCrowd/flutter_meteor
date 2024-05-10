import '../../core/plugin/hz_router_plugin_method_channel.dart';

/// 实现Native层页面路由
class HzRouterPlugin {
  final HzRouterPluginMethodChannel _pluginPlatform = HzRouterPluginMethodChannel();
  void setCustomMethodCallHandler(
      {required Function(String method, dynamic arguments) customMethodCallHandler}) async {
    _pluginPlatform.setCustomMethodCallHandler(customMethodCallHandler: customMethodCallHandler);
  }

  Future<T?> invokeMethod<T extends Object?>(
      {required String method, Map<String, dynamic>? arguments}) async {
    return await _pluginPlatform.invokeMethod<T>(method: method, arguments: arguments);
  }
}
