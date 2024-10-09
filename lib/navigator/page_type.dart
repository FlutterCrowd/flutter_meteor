/// 页面类型枚举
enum PageType {
  ///flutter页面
  flutter(0),

  ///原生页面
  native(1),

  ///通用新引擎打开flutter页面
  newEngine(2);

  const PageType(this.type);
  final int type;

  static PageType fromType(dynamic type) {
    return PageType.values.firstWhere(
      (element) => element.type == type,
      orElse: () => PageType.flutter,
    );
  }
}
