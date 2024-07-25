mixin MeteorChannelMethod {
  static const String pushNamedMethod = 'pushNamed';
  static const String pushReplacementNamedMethod = 'pushReplacementNamed';
  static const String pushNamedAndRemoveUntilMethod = 'pushNamedAndRemoveUntil';
  static const String pushNamedAndRemoveUntilRootMethod = 'pushNamedAndRemoveUntilRoot';
  static const String popMethod = 'pop';
  static const String popUntilMethod = 'popUntil';
  static const String popToRootMethod = 'popToRoot';
  static const String dismissMethod = 'dismiss';
  static const String multiEngineEventCallMethod = 'cn.itbox.multiEnginEvent';

  /// route stack
  static const String routeExists = 'routeExists';
  static const String isRoot = 'isRoot';
  static const String rootRouteName = 'rootRouteName';
  static const String topRouteName = 'topRouteName';
  static const String routeNameStack = 'routeNameStack';
  static const String topRouteIsNative = 'topRouteIsNative';
}
