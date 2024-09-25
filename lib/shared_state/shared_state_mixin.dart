import 'package:flutter_meteor/flutter_meteor.dart';

mixin GlobalSharedStateMixin {
  Future<void> setString(String key, String? value) async {
    await SharedMemoryCache.setString(key, value);
  }

  Future<String?> getString(String key) async {
    return await SharedMemoryCache.getString(key);
  }

  Future<void> setBool(String key, bool? value) async {
    await SharedMemoryCache.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    return await SharedMemoryCache.getBool(key);
  }

  Future<void> setInt(String key, int? value) async {
    await SharedMemoryCache.setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    return await SharedMemoryCache.getInt(key);
  }

  Future<void> setDouble(String key, double? value) async {
    await SharedMemoryCache.setDouble(key, value);
  }

  Future<double?> getDouble(String key) async {
    return await SharedMemoryCache.getDouble(key);
  }

  Future<void> setList(String key, List<dynamic>? value) async {
    await SharedMemoryCache.setList(key, value);
  }

  Future<List<dynamic>?> getList(String key) async {
    return await SharedMemoryCache.getList(key);
  }

  Future<void> setMap(String key, Map<String, dynamic>? value) async {
    await SharedMemoryCache.setMap(key, value);
  }

  Future<Map<String, dynamic>?> getMap(String key) async {
    return await SharedMemoryCache.getMap(key);
  }

  Future<void> setBytes(String key, List<int>? value) async {
    await SharedMemoryCache.setBytes(key, value);
  }

  Future<List<int?>?> getBytes(String key) async {
    return await SharedMemoryCache.getBytes(key);
  }

  Future<void> setValue(String key, dynamic value) async {
    await SharedMemoryCache.setValue(key, value);
  }

  Future<dynamic> getValue(String key) async {
    return await SharedMemoryCache.getValue(key);
  }

  /// 缓存对象
  /// T 是继承自MeteorSharedObject类的的对象
  Future<void> setObject<T extends MeteorSharedObject>(String key, T? value) async {
    await SharedMemoryCache.setMap(key, value?.toJson());
  }

  /// 获取缓存对象
  /// T 是继承自MeteorSharedObject类的的对象
  Future<T?> getObject<T extends MeteorSharedObject>(String key, T Function() constructor) async {
    return await SharedMemoryCache.getObject<T>(key, constructor);
  }
}
