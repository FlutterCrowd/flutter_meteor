import 'package:flutter/cupertino.dart';
import 'package:flutter_meteor/cache/shared_cache_api.dart';
import 'package:flutter_meteor/flutter_meteor.dart';

abstract class MeteorBasicSharedProvider<T> extends ChangeNotifier {
  MeteorBasicSharedProvider({String? stateKey, T? initialValue}) {
    print('当前类：$runtimeType');
    _sharedState = initialValue;
    _stateKey = stateKey ?? runtimeType.toString();
    MeteorEventBus.addListener(
      eventName: _eventName,
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

class MeteorStringProvider extends MeteorBasicSharedProvider<String> {
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

class MeteorIntProvider extends MeteorBasicSharedProvider<int> {
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

class MeteorDoubleProvider extends MeteorBasicSharedProvider<double> {
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

class MeteorBoolProvider extends MeteorBasicSharedProvider<bool> {
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

class MeteorListProvider extends MeteorBasicSharedProvider<List<dynamic>> {
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

class MeteorMapProvider extends MeteorBasicSharedProvider<Map<String, dynamic>> {
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

class MeteorBytesProvider extends MeteorBasicSharedProvider<List<int?>> {
  MeteorBytesProvider({String? stateKey, List<int>? initialValue})
      : super(stateKey: stateKey, initialValue: initialValue);

  @override
  Future<List<int?>?> fetchState() async {
    return await _cacheApi.getBytes(stateKey);
  }

  @override
  Future<void> updateState(List<int?>? newState) async {
    await _cacheApi.setBytes(stateKey, newState);
    super.updateState(newState);
  }
}

class MeteorValueProvider<T> extends MeteorBasicSharedProvider<T> {
  MeteorValueProvider({String? stateKey, T? initialValue})
      : super(stateKey: stateKey, initialValue: initialValue);
  @override
  Future<T?> fetchState() async {
    T? state = await _cacheApi.getValue(stateKey) as T?;
    _sharedState = state;
    return state;
  }

  // Update state on both Flutter and native platform
  @override
  Future<void> updateState(T? newState) async {
    await _cacheApi.setValue(stateKey, newState);
    return await super.updateState(newState);
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
