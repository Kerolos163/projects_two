import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {
  static late final SharedPreferences _preferences;

  static init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // set
  static Future<bool> setString(String key, String value) async {
    return await _preferences.setString(key, value);
  }

  static Future<bool> setBool(String key, bool value) async {
    return await _preferences.setBool(key, value);
  }

  static Future<bool> setDouble(String key, double value) async {
    return await _preferences.setDouble(key, value);
  }

  static Future<bool> setInt(String key, int value) async {
    return await _preferences.setInt(key, value);
  }

  static Future<bool> setStringList(String key, List<String> value) async {
    return await _preferences.setStringList(key, value);
  }

  // get
  static String? getString(String key) {
    return _preferences.getString(key);
  }

  static bool? getBool(String key) {
    return _preferences.getBool(key);
  }

  static int? getInt(String key) {
    return _preferences.getInt(key);
  }

  static double? getDouble(String key) {
    return _preferences.getDouble(key);
  }

  static List<String>? getStringList(String key) {
    return _preferences.getStringList(key);
  }

  // delete
  static remove(String key) async {
    await _preferences.remove(key);
  }

  static clear() async {
    await _preferences.clear();
  }
}
