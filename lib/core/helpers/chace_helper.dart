import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum CacheKey {
  theme,
  language,
  userName,
  userBio,
  userImageUrl,
  userCountryCode,
  lastOpenedPage,
  sortingOption,
  filterOption,
  pushNotificationsEnabled,
  lastUpdateTime,
  offlineData,
  appUsageTime,
  appOpenCount,
  userLink,
  languageCode,
  countryCode,
  uid,
  email,
  postId
  // башка ачкычтарды кошуңуз
}

class CacheHelper {
  static late SharedPreferences _prefs;
  static final Map<String, dynamic> _cache = {};
  static final _secureStorage = FlutterSecureStorage();

  static FutureOr<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static FutureOr<bool> setString(CacheKey key, String value) async {
    _cache[key.toString()] = value;
    return await _prefs.setString(key.toString(), value);
  }

  static FutureOr<bool> setInt(CacheKey key, int value) async {
    _cache[key.toString()] = value;
    return await _prefs.setInt(key.toString(), value);
  }

  static FutureOr<bool> setBool(CacheKey key, bool value) async {
    _cache[key.toString()] = value;
    return await _prefs.setBool(key.toString(), value);
  }

  static FutureOr<bool> setDouble(CacheKey key, double value) async {
    _cache[key.toString()] = value;
    return await _prefs.setDouble(key.toString(), value);
  }

  static String? getString(CacheKey key) {
    if (_cache.containsKey(key.toString())) {
      return _cache[key.toString()] as String?;
    }
    return _prefs.getString(key.toString());
  }

  static int? getInt(CacheKey key) {
    if (_cache.containsKey(key.toString())) {
      return _cache[key.toString()] as int?;
    }
    return _prefs.getInt(key.toString());
  }

  static bool? getBool(CacheKey key) {
    if (_cache.containsKey(key.toString())) {
      return _cache[key.toString()] as bool?;
    }
    return _prefs.getBool(key.toString());
  }

  static double? getDouble(CacheKey key) {
    if (_cache.containsKey(key.toString())) {
      return _cache[key.toString()] as double?;
    }
    return _prefs.getDouble(key.toString());
  }

  static FutureOr<bool> remove(CacheKey key) async {
    _cache.remove(key.toString());
    return await _prefs.remove(key.toString());
  }

  static FutureOr<void> clear() async {
    _cache.clear();
    await _prefs.clear();
  }

  // Маанилүү маалыматтар үчүн шифрленген сактоо
  static Future<void> setSecure(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  static Future<String?> getSecure(String key) async {
    return await _secureStorage.read(key: key);
  }

  static Future<void> removeSecure(String key) async {
    await _secureStorage.delete(key: key);
  }
}
