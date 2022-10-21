import 'package:shared_preferences/shared_preferences.dart';

class KeyValueStorage {
  SharedPreferences? _storage;

  void init() async {
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

  int? getInt(String key) {
    return _storage!.getInt(key);
  }

  bool? getBool(String key) {
    return _storage!.getBool(key);
  }

  double? getDouble(String key) {
    return _storage!.getDouble(key);
  }
}
