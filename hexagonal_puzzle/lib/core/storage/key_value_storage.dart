import 'package:shared_preferences/shared_preferences.dart';

class KeyValueStorage {
  SharedPreferences? _storage;

  void setInt(String key, int value) async {
    final storage = await _getStorage();
    storage.setInt(key, value);
  }

  void setBool(String key, bool value) async {
    final storage = await _getStorage();
    storage.setBool(key, value);
  }

  Future<int?> getInt(String key) async {
    final storage = await _getStorage();
    return storage.getInt(key);
  }

  Future<bool?> getBool(String key) async {
    final storage = await _getStorage();
    return storage.getBool(key);
  }

  Future<SharedPreferences> _getStorage() async {
    SharedPreferences? storage = _storage;

    if (storage == null) {
      storage = await SharedPreferences.getInstance();
      _storage = storage;
    }

    return storage;
  }
}
