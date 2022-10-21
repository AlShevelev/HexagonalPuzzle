import '../../storages/key_value_storage.dart';
import 'settings_default.dart';
import 'settings_keys.dart';

class SettingsRepository {
  late final KeyValueStorage _storage;

  Future<void> init() async {
    _storage = KeyValueStorage();
    _storage.init();
  }

  void setMusicOn(bool value) async {
    _storage.setBool(SettingsKeys.musicOn, value);
  }

  void setSoundOn(bool value) async {
    _storage.setBool(SettingsKeys.soundOn, value);
  }

  /// 0 - small; 1 - average; 2 - large
  void setFieldSize(int value) async {
    _storage.setInt(SettingsKeys.fieldSize, value);
  }

  /// As a percent of a total pieces number
  void setNumberOfPermutations(double value) async {
    _storage.setDouble(SettingsKeys.numberOfPermutations, value);
  }

  void setRotations(bool value) async {
    _storage.setBool(SettingsKeys.rotations, value);
  }

  bool getMusicOn() {
    return _storage.getBool(SettingsKeys.musicOn) ?? SettingsDefault.musicOn;
  }

  bool getSoundOn() {
    return _storage.getBool(SettingsKeys.soundOn) ?? SettingsDefault.musicOn;
  }

  /// 0 - small; 1 - average; 2 - large
  int? getFieldSize() {
    return _storage.getInt(SettingsKeys.fieldSize) ?? SettingsDefault.fieldSize;
  }

  /// As a percent of a total pieces number
  double getNumberOfPermutations() {
    return _storage.getDouble(SettingsKeys.numberOfPermutations) ?? SettingsDefault.numberOfPermutations;
  }

  bool getRotations(bool value) {
    return _storage.getBool(SettingsKeys.rotations) ?? SettingsDefault.rotations;
  }
}
