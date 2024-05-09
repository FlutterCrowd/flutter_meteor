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

  // /// push 到一个已经存在路由表的页面
  // ///
  // /// @parma routeName 要跳转的页面，
  // /// @return T  泛型，用于指定返回类型
  // Future<T?> pushNamed<T extends Object?>({
  //   required String routeName,
  //   Map<String, dynamic>? arguments,
  // });
  //
  // /// push 到指定页面并替换当前页面
  // ///
  // /// @parma routeName 要跳转的页面，
  // /// @return T  泛型，用于指定返回类型
  // Future<T?> pushReplacementNamed<T extends Object?>(
  //     {required String routeName, Map<String, dynamic>? arguments});
  //
  // /// push 到指定页面，同时会清除从页面untilRouteName页面到指定routeName链路上的所有页面
  // ///
  // /// @parma routeName 要跳转的页面，
  // /// @parma untilRouteName 移除截止页面，默认跟试图'/'，
  // /// @return T  泛型，用于指定返回类型
  // Future<T?> pushNamedAndRemoveUntil<T extends Object?>({
  //   required String routeName,
  //   String? untilRouteName,
  //   Map<String, dynamic>? arguments,
  // });
  //
  // /// pop到上一个页面
  // ///
  // /// @parma result 接受回调，T是个泛型，可以指定要返回的数据类型
  // Future<T?> pop<T extends Object?>({T? result});
  //
  // /// pop 到指定页面并替换当前页面
  // ///
  // /// @parma routeName 要pod到的页面
  // Future<T?> popUntil<T extends Object?>({required String routeName});
  //
  // /// pop 到根页面
  // Future<T?> popToRoot<T extends Object?>();
}
