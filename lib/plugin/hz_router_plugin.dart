import 'package:flutter/services.dart';

import 'hz_router_plugin_method_channel.dart';
import 'hz_router_plugin_platform_interface.dart';

class HzRouterPlugin {
  final bool needNewChannel;
  late HzRouterPluginPlatform _hzRouterPlugin;
  HzRouterPlugin({this.needNewChannel = false}) {
    if (needNewChannel) {
      _hzRouterPlugin = MethodChannelHzRouterPlugin(
          methodChannel: const MethodChannel('cn.itbox.router.multi_engine.methodChannel'));
    } else {
      _hzRouterPlugin = HzRouterPluginPlatform.instance;
    }
  }

  Future<String?> getPlatformVersion() {
    return _hzRouterPlugin.getPlatformVersion();
  }

  /// 原生返回上一级
  Future<Map<String, dynamic>?> pop({Map<String, dynamic>? arguments}) async {
    return _hzRouterPlugin.pop();
  }

  /// 原生返回根试图
  Future<Map<String, dynamic>?> popToRoot({Map<String, dynamic>? arguments}) async {
    return _hzRouterPlugin.popToRoot();
  }

  /// 原生push到新的页面
  Future<Map<String, dynamic>?> push(
      {required String routerName, Map<String, dynamic>? arguments}) async {
    return _hzRouterPlugin.push(routerName: routerName, arguments: arguments);
  }
}
