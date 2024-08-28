/// 页面类型枚举
enum MeteorPageType {
  ///flutter页面
  flutter(0),

  ///原生页面
  native(1),

  ///通用新引擎打开flutter页面
  newEngine(2),

  ///web页面
  web(3);

  const MeteorPageType(this.type);
  final int type;

  static MeteorPageType fromType(dynamic type) {
    return MeteorPageType.values.firstWhere(
      (element) => element.type == type,
      orElse: () => MeteorPageType.flutter,
    );
  }
}
