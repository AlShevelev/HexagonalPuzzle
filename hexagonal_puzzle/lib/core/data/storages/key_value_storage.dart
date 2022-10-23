import 'package:shared_preferences/shared_preferences.dart';

class KeyValueStorage {
  SharedPreferences? _storage;

  Future<void> init() async {
    _storage = await SharedPreferences.getInstance();
  }

  void setInt(String key, int value) {
    _storage!.setInt(key, value);
  }

  void setBool(String key, bool value) {
    _storage!.setBool(key, value);
  }

  void setDouble(String key, double value) {
    _storage!.setDouble(key, value);
  }

  void setString(String key, String value) {
    _storage!.setString(key, value);
  }

  int? getInt(String key) {
    return _storage!.getInt(key);
  }

  bool? getBool(String key) {
    return _storage!.getBool(key);
  }

  double? getDouble(String key) {
    return _storage!.getDouble(key);
  }

  String? getString(String key) {
    return _storage!.getString(key);
  }
}
