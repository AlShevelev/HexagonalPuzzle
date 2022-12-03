import '../../storages/key_value_storage.dart';
import 'settings_default.dart';
import 'settings_keys.dart';

class SettingsRepository {
  late final KeyValueStorage _storage;

  Future<void> init() async {
    _storage = KeyValueStorage();
    _storage.init();
  }

  void setMusicOn(bool value) {
    _storage.setBool(SettingsKeys.musicOn, value);
  }

  void setSoundOn(bool value) {
    _storage.setBool(SettingsKeys.soundOn, value);
  }

  /// few - 0; several - 1, many - 2
  /// return - actual value
  int setNumberOfPieces(int value) {
    final int newValue;
    if (value < 0 || value > 2) {
      newValue = 0;
    } else {
      newValue = value;
    }
    _storage.setInt(SettingsKeys.numberOfPieces, newValue);

    return newValue;
  }

  /// easy - 0,  quite easy - 1,  medium difficulty - 2, not so hard - 3, hard - 4
  /// return - actual value
  int setNumberOfPermutations(int value) {
    final int newValue;
    if (value < 0 || value > 4) {
      newValue = 0;
    } else {
      newValue = value;
    }

    _storage.setInt(SettingsKeys.numberOfPermutations, newValue);
    return newValue;
  }

  void setPiecesTurningOn(bool value) {
    _storage.setBool(SettingsKeys.piecesTurning, value);
  }

  bool getMusicOn() {
    return _storage.getBool(SettingsKeys.musicOn) ?? SettingsDefault.musicOn;
  }

  bool getSoundOn() {
    return _storage.getBool(SettingsKeys.soundOn) ?? SettingsDefault.musicOn;
  }

  /// few - 0; several - 1, average - 2; large - 3
  int getNumberOfPieces() {
    return _storage.getInt(SettingsKeys.numberOfPieces) ?? SettingsDefault.numberOfPieces;
  }

  /// easy - 0,  quite easy - 1,  medium difficulty - 2, not so hard - 3, hard - 4
  int getNumberOfPermutations() {
    return _storage.getInt(SettingsKeys.numberOfPermutations) ?? SettingsDefault.numberOfPermutations;
  }

  bool getPiecesTurningOn() {
    return _storage.getBool(SettingsKeys.piecesTurning) ?? SettingsDefault.piecesTurning;
  }
}
