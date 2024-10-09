import 'package:flutter_meteor/flutter_meteor.dart';

class User {
  String? name;
  int? age;
  int? gender;

  User({
    this.name,
    this.age,
    this.gender,
  });

  // User.fromJson(Map<String, dynamic>? json) {
  //   setupFromJson(json);
  // }

  @override
  User.fromJson(Map<String, dynamic>? json) {
    name = json?['name'] ?? 'name';
    age = json?['age'] ?? 18;
    gender = json?['gender'] ?? 1;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
    };
  }
}

class GlobalUserStateManager extends MeteorSharedObject {
  // 私有的构造方法，防止外部直接实例化
  GlobalUserStateManager._internal() : super(initialFromCache: true);

  // 保存唯一的实例
  static final GlobalUserStateManager _instance = GlobalUserStateManager._internal();

  // 提供一个工厂构造函数，返回唯一的实例
  factory GlobalUserStateManager() {
    return _instance;
  }

  bool? _isOnline;
  set isOnline(bool value) {
    _isOnline = value;
    // saveToSharedCache();
  }

  bool get isOnline => _isOnline ?? false;

  /// 是否在线
  User? user;

  @override
  void setupFromJson(Map<String, dynamic>? json) {
    isOnline = json?['isOnline'] ?? false;
    user = User.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'isOnline': isOnline,
      'user': user?.toJson(),
    };
  }
}

class GlobalAppStateManager extends MeteorSharedObject {
  // 私有的构造方法，防止外部直接实例化
  GlobalAppStateManager._internal() : super(initialFromCache: true);

  // 保存唯一的实例
  static final GlobalAppStateManager _instance = GlobalAppStateManager._internal();

  // 提供一个工厂构造函数，返回唯一的实例
  factory GlobalAppStateManager() {
    return _instance;
  }

  bool? _didShowProtocolPage;
  bool? _didShowAlert;
  set didShowProtocolPage(bool value) {
    _didShowProtocolPage = value;
    // saveToSharedCache();
  }

  bool get didShowProtocolPage => _didShowProtocolPage ?? false;

  set didShowAlert(bool value) {
    _didShowAlert = value;
    // saveToSharedCache();
  }

  bool get didShowAlert => _didShowAlert ?? false;

  @override
  void setupFromJson(Map<String, dynamic>? json) {
    didShowProtocolPage = json?['didShowProtocolPage'] ?? false;
    didShowAlert = json?['didShowAlert'] ?? false;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'didShowProtocolPage': didShowProtocolPage,
      'didShowAlert': didShowAlert,
    };
  }
}
