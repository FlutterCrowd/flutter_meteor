import 'package:flutter/cupertino.dart';
import 'package:flutter_meteor/cache/shared_cache_api.dart';
import 'package:flutter_meteor/flutter_meteor.dart';

abstract class MeteorStateProvider<T> extends ChangeNotifier {
  MeteorStateProvider({String? stateKey, T? initialValue}) {
    print('当前类：$runtimeType');
    _sharedState = initialValue;
    _stateKey = stateKey ?? runtimeType.toString();
    MeteorEventBus.addListener(
      eventName: _eventName!,
      listener: (dynamic data) {
        if (data is T) {
          _updateCurrentEngineState(data);
        }
      },
    );
    _setupState();
  }

  final _cacheApi = SharedCacheApi();
  String? _stateKey;
  String get stateKey => _stateKey ?? runtimeType.toString();
  String get _eventName => '$runtimeType-$_stateKey-${T.runtimeType}';

  T? _sharedState;
  T? get sharedState => _sharedState;

  void _setupState() async {
    T? state = await fetchState();
    _updateCurrentEngineState(state);
  }

  // Fetch state from native platform
  Future<T?> fetchState();

  // Update state on both Flutter and native platform
  Future<void> updateState(T? newState) async {
    _updateCurrentEngineState(newState);
    MeteorEventBus.commit(eventName: _eventName, data: newState);
  }

  void _updateCurrentEngineState(T? newState) {
    if (newState != _sharedState) {
      _sharedState = newState;
      notifyListeners();
    }
  }
}

class MeteorStringProvider extends MeteorStateProvider<String> {
  MeteorStringProvider({String? stateKey, String? initialValue})
      : super(stateKey: stateKey, initialValue: initialValue);

  @override
  Future<String?> fetchState() async {
    return await _cacheApi.getString(stateKey);
  }

  @override
  Future<void> updateState(String? newState) async {
    await _cacheApi.setString(stateKey, newState);
    super.updateState(newState);
  }
}

class MeteorIntProvider extends MeteorStateProvider<int> {
  MeteorIntProvider({String? stateKey, int? initialValue})
      : super(stateKey: stateKey, initialValue: initialValue);

  @override
  Future<int?> fetchState() async {
    return await _cacheApi.getInt(stateKey);
  }

  @override
  Future<void> updateState(int? newState) async {
    await _cacheApi.setInt(stateKey, newState);
    super.updateState(newState);
  }
}

class MeteorDoubleProvider extends MeteorStateProvider<double> {
  MeteorDoubleProvider({String? stateKey, double? initialValue})
      : super(stateKey: stateKey, initialValue: initialValue);

  @override
  Future<double?> fetchState() async {
    return await _cacheApi.getDouble(stateKey);
  }

  @override
  Future<void> updateState(double? newState) async {
    await _cacheApi.setDouble(stateKey, newState);
    super.updateState(newState);
  }
}

class MeteorBoolProvider extends MeteorStateProvider<bool> {
  MeteorBoolProvider({String? stateKey, bool? initialValue})
      : super(stateKey: stateKey, initialValue: initialValue);

  @override
  Future<bool?> fetchState() async {
    return await _cacheApi.getBool(stateKey);
  }

  @override
  Future<void> updateState(bool? newState) async {
    await _cacheApi.setBool(stateKey, newState);
    super.updateState(newState);
  }
}

class MeteorListProvider extends MeteorStateProvider<List<dynamic>> {
  MeteorListProvider({String? stateKey, List<dynamic>? initialValue})
      : super(stateKey: stateKey, initialValue: initialValue);

  @override
  Future<List?> fetchState() async {
    return await _cacheApi.getList(stateKey);
  }

  @override
  Future<void> updateState(List? newState) async {
    await _cacheApi.setList(stateKey, newState);
    super.updateState(newState);
  }
}

class MeteorMapProvider extends MeteorStateProvider<Map<String, dynamic>> {
  MeteorMapProvider({String? stateKey, Map<String, dynamic>? initialValue})
      : super(stateKey: stateKey, initialValue: initialValue);

  @override
  Future<Map<String, dynamic>?> fetchState() async {
    return await getMap(_stateKey!);
  }

  Future<Map<String, dynamic>?> getMap(String key) async {
    final result = await _cacheApi.getMap(key);
    if (result != null) {
      Map<String, dynamic>? map = {};
      result.forEach((key, value) {
        if (key != null) {
          map[key] = value;
        }
      });
      return map;
    }
    return null;
  }

  @override
  Future<void> updateState(Map<String, dynamic>? newState) async {
    await _cacheApi.setMap(stateKey, newState);
    super.updateState(newState);
  }
}

class MeteorBytesProvider extends MeteorStateProvider<List<int>> {
  MeteorBytesProvider({String? stateKey, List<int>? initialValue})
      : super(stateKey: stateKey, initialValue: initialValue);

  @override
  Future<List<int>?> fetchState() async {
    return await _cacheApi.getBytes(stateKey) as List<int>?;
  }

  @override
  Future<void> updateState(List<int>? newState) async {
    await _cacheApi.setBytes(stateKey, newState);
    super.updateState(newState);
  }
}

class MeteorValueProvider<T> extends MeteorStateProvider<T> {
  MeteorValueProvider({String? stateKey, T? initialValue})
      : super(stateKey: stateKey, initialValue: initialValue);
  @override
  Future<T?> fetchState() async {
    T? state;
    if (T.runtimeType == String) {
      state = await _cacheApi.getString(stateKey) as T?;
    } else if (T.runtimeType == bool) {
      state = await _cacheApi.getBool(stateKey) as T?;
    } else if (T.runtimeType == int) {
      state = await _cacheApi.getInt(stateKey) as T?;
    } else if (T.runtimeType == double) {
      state = await _cacheApi.getDouble(stateKey) as T?;
    } else if (T.runtimeType == List) {
      state = await _cacheApi.getList(stateKey) as T?;
    } else if (T.runtimeType == Map) {
      state = getMap(stateKey) as T?;
    } else if (T.runtimeType == List<int>) {
      state = await _cacheApi.getBytes(stateKey) as T?;
    } else {
      print('Error fetchState with nonsupport state type ${T.runtimeType}');
    }
    _sharedState = state;
    return state;
  }

  // Update state on both Flutter and native platform
  @override
  Future<void> updateState(T? newState) async {
    if (newState is String) {
      await _cacheApi.setString(stateKey, newState);
    } else if (newState is bool) {
      await _cacheApi.setBool(stateKey, newState);
    } else if (newState is int) {
      await _cacheApi.setInt(stateKey, newState);
    } else if (newState is double) {
      await _cacheApi.setDouble(stateKey, newState);
    } else if (newState is List) {
      await _cacheApi.setList(stateKey, newState);
    } else if (newState is Map<String, dynamic>) {
      await _cacheApi.setMap(stateKey, newState);
    } else if (newState is List<int>) {
      await _cacheApi.setBytes(stateKey, newState);
    } else {
      print('Error with updateState nonsupport state type ${newState.runtimeType}');
    }
    MeteorEventBus.commit(eventName: stateKey, data: newState);
  }

  Future<Map<String, dynamic>?> getMap(String key) async {
    final result = await _cacheApi.getMap(key);
    if (result != null) {
      Map<String, dynamic>? map = {};
      result.forEach((key, value) {
        if (key != null) {
          map[key] = value;
        }
      });
      return map;
    }
    return null;
  }
}

abstract class MeteorModel<T> {
  void setupFromJson(Map<String, dynamic>? json);
  Map<String, dynamic> toJson();

  Map<String, dynamic> copyWithJson(Map<String, dynamic> json) {
    Map<String, dynamic> modelJson = toJson();
    for (var key in json.keys) {
      if (!modelJson.containsKey(key) || modelJson[key] != json[key]) {
        modelJson[key] = json[key];
      }
    }
    return modelJson;
  }
}

class MeteorModelProvider<T extends MeteorModel> with ChangeNotifier {
  MeteorModelProvider({String? stateKey, required T model}) {
    _model = model;
    _stateKey = stateKey ?? runtimeType.toString();
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

  final _cacheApi = SharedCacheApi();
  late String _stateKey;
  String get stateKey => _stateKey;
  late T _model;
  T get model => _model;
  set model(T value) {
    _model = value;
    notifyListeners();
    update();
  }

  void update() async {
    final data = model.toJson();
    await _cacheApi.setMap(_stateKey, data);
    MeteorEventBus.commit(eventName: _eventName, data: data);
  }

  void updateWithModel(T newModel) async {
    model = newModel;
  }

  void updateWithJson(Map<String, dynamic> json) async {
    model.setupFromJson(json);
    update();
  }

  String get _eventName => '$runtimeType-$_stateKey-${model.runtimeType}';

  void _setupState() async {
    final result = await _cacheApi.getMap(_stateKey);
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
