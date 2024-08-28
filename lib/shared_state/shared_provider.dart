import 'package:flutter/cupertino.dart';
import 'package:flutter_meteor/flutter_meteor.dart';

/// 多引擎共享状态类基类，可以实现跨引擎共享状态，不管在哪个引擎上更新状态都能同步到其他引擎

class MeteorSharedProvider<T extends MeteorSharedObject> with ChangeNotifier {
  MeteorSharedProvider({required T model}) {
    _model = model;
    MeteorEventBus.addListener(
      eventName: _eventName,
      listener: (dynamic data) {
        if (data is Map) {
          _updateWithJson(data);
        }
      },
    );
    _setupState();
  }

  late T _model;
  T get model => _model;
  set model(T value) {
    _model = value;
    notifyListeners();
    update();
  }

  String get _stateKey => '${runtimeType.toString()}-${model.runtimeType}';
  String get _eventName => 'MeteorEvent-$_stateKey}';

  void update() async {
    final data = model.toJson();
    await SharedMemoryCache.setMap(_stateKey, data);
    MeteorEventBus.commit(eventName: _eventName, data: data);
  }

  void updateWithJson(Map<String, dynamic> json) async {
    model.setupFromJson(json);
    update();
  }

  void _setupState() async {
    final result = await SharedMemoryCache.getMap(_stateKey);
    _updateWithJson(result ?? {});
  }

  Future<void> _updateWithJson(Map json) async {
    Map<String, dynamic>? map = {};
    json.forEach(
      (key, value) {
        if (key != null) {
          map[key] = value;
        }
      },
    );
    final modelJson = model.toJson();
    model.setupFromJson(map);
    if (!_areMapsEqual(json, modelJson)) {
      notifyListeners();
    }
  }

  bool _areMapsEqual(Map map1, Map map2) {
    if (map1.length != map2.length) {
      return false;
    }
    for (var key in map1.keys) {
      if (!map2.containsKey(key) || map1[key] != map2[key]) {
        return false;
      }
    }
    return true;
  }
}
