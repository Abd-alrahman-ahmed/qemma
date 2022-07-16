// ignore_for_file: constant_identifier_names
import 'package:qemma_mobile/helpers/app_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SharedPreferenceKeys { lang, user_data }

class SharedPreference {
  static SharedPreferences? _prefs;

  static Future<void> _init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<bool> clear() async {
    if (_prefs != null) {
      return await _prefs!.clear();
    }
    return true;
  }

  static Future<T> getData<T>({
    required SharedPreferenceKeys key,
    required dynamic Function(dynamic) mapper,
  }) async {
    await _init();
    var data = _prefs!.get(key.toName());
    return mapper(data);
  }

  static Future<bool> setInt({
    required SharedPreferenceKeys key,
    required int value,
  }) async {
    await _init();
    return await _prefs!.setInt(key.toName(), value);
  }

  static Future<bool> setDouble({
    required SharedPreferenceKeys key,
    required double value,
  }) async {
    await _init();
    return await _prefs!.setDouble(key.toName(), value);
  }

  static Future<bool> setBool({
    required SharedPreferenceKeys key,
    required bool value,
  }) async {
    await _init();
    return await _prefs!.setBool(key.toName(), value);
  }

  static Future<bool> setString({
    required SharedPreferenceKeys key,
    required String value,
  }) async {
    await _init();
    return await _prefs!.setString(key.toName(), value);
  }

  static Future<bool> setStringList({
    required SharedPreferenceKeys key,
    required List<String> values,
  }) async {
    await _init();
    return await _prefs!.setStringList(key.toName(), values);
  }
}
