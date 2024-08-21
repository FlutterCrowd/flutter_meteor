import 'shared_cache_api.dart';

class SharedMemoryCache {
  static final _cacheApi = SharedCacheApi();
  static Future<void> setString(String key, String? value) async {
    await _cacheApi.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    return await _cacheApi.getString(key);
  }

  static Future<void> setBool(String key, bool? value) async {
    await _cacheApi.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    return await _cacheApi.getBool(key);
  }

  static Future<void> setInt(String key, int? value) async {
    await _cacheApi.setInt(key, value);
  }

  static Future<int?> getInt(String key) async {
    return await _cacheApi.getInt(key);
  }

  static Future<void> setDouble(String key, double? value) async {
    await _cacheApi.setDouble(key, value);
  }

  static Future<double?> getDouble(String key) async {
    return await _cacheApi.getDouble(key);
  }

  static Future<void> setList(String key, List<dynamic>? value) async {
    await _cacheApi.setList(key, value);
  }

  static Future<List<dynamic>?> getList(String key) async {
    return await _cacheApi.getList(key);
  }

  static Future<void> setMap(String key, Map<String, dynamic>? value) async {
    await _cacheApi.setMap(key, value);
  }

  static Future<Map<String, dynamic>?> getMap(String key) async {
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

  static Future<void> setBytes(String key, List<int>? value) async {
    await _cacheApi.setBytes(key, value);
  }

  static Future<List<int>?> getBytes(String key) async {
    return await _cacheApi.getBytes(key) as List<int>?;
  }

  // static Future<void> setValue(String key, dynamic value) async {
  //   await _cacheApi.set(key, value);
  // }
  //
  // static Future<dynamic> getValue(String key) async {
  //   return await _cacheApi.ge(key);
  // }

  getPlatformVersion() {}
}
