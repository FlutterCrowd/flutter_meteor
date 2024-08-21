import '../cache/shared_cache_api.dart';

mixin GlobalSharedStateMixin {
  final _cacheApi = SharedCacheApi();
  Future<void> setString(String key, String? value) async {
    await _cacheApi.setString(key, value);
  }

  Future<String?> getString(String key) async {
    return await _cacheApi.getString(key);
  }

  Future<void> setBool(String key, bool? value) async {
    await _cacheApi.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    return await _cacheApi.getBool(key);
  }

  Future<void> setInt(String key, int? value) async {
    await _cacheApi.setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    return await _cacheApi.getInt(key);
  }

  Future<void> setDouble(String key, double? value) async {
    await _cacheApi.setDouble(key, value);
  }

  Future<double?> getDouble(String key) async {
    return await _cacheApi.getDouble(key);
  }

  Future<void> setList(String key, List<dynamic>? value) async {
    await _cacheApi.setList(key, value);
  }

  Future<List<dynamic>?> getList(String key) async {
    return await _cacheApi.getList(key);
  }

  Future<void> setMap(String key, Map<String, dynamic>? value) async {
    await _cacheApi.setMap(key, value);
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

  Future<void> setBytes(String key, List<int>? value) async {
    await _cacheApi.setBytes(key, value);
  }

  Future<List<int>?> getBytes(String key) async {
    return await _cacheApi.getBytes(key) as List<int>?;
  }
}
