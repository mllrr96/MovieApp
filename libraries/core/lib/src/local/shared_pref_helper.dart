import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  final SharedPreferences preferences;

  SharedPrefHelper({required this.preferences});

  static const _LAST_CHECKED = "last_checked";
  static const _CHECK_INTERVAL = "check_interval";
  static const _DATA = "data";
  // static const _THEME = "theme";
  static const _THEME_MODE = "theme_mode";

  // Interval 600000 means handle cache for 600000 milliseconds or 10 minutes
  Future<bool> storeCache(String key, String json,
      {int? lastChecked, int interval = 600000}) {
    if (lastChecked == null) {
      lastChecked = DateTime.now().millisecondsSinceEpoch;
    }
    return preferences.setString(
        key,
        jsonEncode({
          _LAST_CHECKED: lastChecked,
          _CHECK_INTERVAL: interval,
          _DATA: json
        }));
  }

  Future<String?> getCache(String key) async {
    if (preferences.getString(key) == null) {
      return null;
    }
    Map map = jsonDecode(preferences.getString(key)!);
    // if outdated, clear and return null
    var lastChecked = map[_LAST_CHECKED];
    var interval = map[_CHECK_INTERVAL];
    if ((DateTime.now().millisecondsSinceEpoch - lastChecked) > interval) {
      preferences.remove(key);
      return null;
    }
    return map[_DATA];
  }

  Future<Map?> getFullCache(String key) async {
    if (preferences.getString(key) == null) {
      return null;
    }
    Map map = jsonDecode(preferences.getString(key)!);
    // if outdated, clear and return null
    var lastChecked = map[_LAST_CHECKED];
    var interval = map[_CHECK_INTERVAL];
    if ((DateTime.now().millisecondsSinceEpoch - lastChecked) > interval) {
      preferences.remove(key);
      return null;
    }
    return map;
  }

  Future saveThemeMode(ThemeMode value) async {
    return preferences.setInt(_THEME_MODE, value.index);
  }

  Future<ThemeMode> getThemeMode() async {
    int? themeIndex = preferences.getInt(_THEME_MODE);
    if (themeIndex == null || themeIndex < 0 || themeIndex > 2) {
      return ThemeMode.system;
    }
    return ThemeMode.values[themeIndex];
  }
}
