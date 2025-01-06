import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ExtendedSharedPreferences {
  final Map<String, Object> _preferenceCache;

  ExtendedSharedPreferences._(this._preferenceCache);

  static Completer<ExtendedSharedPreferences>? _completer;

  static Future<ExtendedSharedPreferences> getInstance() async {
    if (_completer == null) {
      final completer = Completer<ExtendedSharedPreferences>();
      _completer = completer;

      try {
        final prefs = await SharedPreferences.getInstance();
        final cache = Map<String, Object>.from(
          prefs.getKeys().fold(
            {},
            (map, key) {
              map[key] = prefs.get(key);
              return map;
            },
          ),
        );
        completer.complete(ExtendedSharedPreferences._(cache));
      } catch (e) {
        completer.completeError(e);
        _completer = null;
      }
    }
    return _completer!.future;
  }

  // Returns all keys
  Set<String> getKeys() => _preferenceCache.keys.toSet();

  // Checks if key exists
  bool containsKey(String key) => _preferenceCache.containsKey(key);

  // Gets raw value
  Object? get(String key) => _preferenceCache[key];

  // Gets bool
  bool? getBool(String key) => _preferenceCache[key] as bool?;

  // Gets int
  int? getInt(String key) => _preferenceCache[key] as int?;

  // Gets double
  double? getDouble(String key) => _preferenceCache[key] as double?;

  // Gets string
  String? getString(String key) => _preferenceCache[key] as String?;

  // Gets list of strings
  List<String>? getStringList(String key) =>
      (_preferenceCache[key] as List<dynamic>?)?.cast<String>();

  // Sets value
  Future<bool> set(String key, Object value) async {
    final prefs = await SharedPreferences.getInstance();
    _preferenceCache[key] = value;

    if (value is bool) {
      return prefs.setBool(key, value);
    }
    if (value is int) {
      return prefs.setInt(key, value);
    }
    if (value is double) {
      return prefs.setDouble(key, value);
    }
    if (value is String) {
      return prefs.setString(key, value);
    }
    if (value is List<String>) {
      return prefs.setStringList(key, value);
    }

    throw UnsupportedError("Unsupported type: ${value.runtimeType}");
  }

  // Removes value
  Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    _preferenceCache.remove(key);
    return prefs.remove(key);
  }

  // Clears all values
  Future<bool> clear() async {
    final prefs = await SharedPreferences.getInstance();
    _preferenceCache.clear();
    return prefs.clear();
  }

  // Sets value as JSON
  Future<bool> setWithJson<T>(
    String key,
    T value,
    Map<String, dynamic> Function(T) toJson,
  ) async {
    final jsonString = jsonEncode(toJson(value));
    return set(key, jsonString);
  }

  // Gets value as JSON
  T? getWithJson<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final jsonString = getString(key);
    if (jsonString == null) {
      return null;
    }

    try {
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      return fromJson(jsonData);
    } catch (e) {
      return null;
    }
  }

  // Reloads the cache from SharedPreferences
  Future<void> reload() async {
    final prefs = await SharedPreferences.getInstance();
    _preferenceCache
      ..clear()
      ..addAll(
        Map<String, Object>.from(
          prefs.getKeys().fold(
            {},
            (map, key) {
              map[key] = prefs.get(key);
              return map;
            },
          ),
        ),
      );
  }
}
