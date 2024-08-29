import 'package:flutter_meteor/cache/shared_memory_cache.dart';

/// 共享对象基类，需要多引擎共享的对象可以通过实现这个接口方便实现共享
///
abstract class MeteorSharedObject {
  bool? initialFromCache = true;
  String? _sharedUniqueKey;

  Future<void> setupFromSharedCache() async {
    Map<String, dynamic>? json = await SharedMemoryCache.getMap(sharedUniqueKey);
    setupFromJson(json);
  }

  MeteorSharedObject({required this.initialFromCache, String? sharedUniqueKey}) {
    _sharedUniqueKey = sharedUniqueKey;
  }

  String get sharedUniqueKey => _sharedUniqueKey ?? 'Meteor-${runtimeType.toString()}';

  void setupFromJson(Map<String, dynamic>? json);
  Map<String, dynamic> toJson();

  Future<void> saveToSharedCache() async {
    await SharedMemoryCache.setMap(sharedUniqueKey, toJson());
    return;
  }

  Map<String, dynamic> copyWithJson(Map<String, dynamic> json) {
    Map<String, dynamic> modelJson = toJson();
    for (var key in json.keys) {
      if (!modelJson.containsKey(key) || modelJson[key] != json[key]) {
        modelJson[key] = json[key];
      }
    }
    return modelJson;
  }

  static Future<T> createFromCache<T extends MeteorSharedObject>(T Function() constructor) async {
    T instance = constructor();
    if (instance.initialFromCache ?? true) {
      await instance.setupFromSharedCache();
    }
    return instance;
  }
}

/// 共享对象管理类，用于注册共享对象，在多引擎中实现单利效果
class MeteorSharedObjectManager {
  static Future<void> registerGlobalInstances(List<MeteorSharedObject> instances) async {
    for (var instance in instances) {
      if (instance.initialFromCache ?? true) {
        await instance.setupFromSharedCache();
      }
    }
  }

  static Future<T> createFromCache<T extends MeteorSharedObject>(T Function() constructor) async {
    T instance = constructor();
    if (instance.initialFromCache ?? true) {
      await instance.setupFromSharedCache();
    }
    return instance;
  }
}
