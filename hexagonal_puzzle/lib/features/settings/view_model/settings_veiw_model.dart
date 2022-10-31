import 'dart:async';

import 'package:hexagonal_puzzle/core/data/repositories/settings/settings_repository.dart';
import 'package:hexagonal_puzzle/core/view_model/view_model_base.dart';

class SettingsViewModel extends ViewModelBase {
  final StreamController<bool> _musicOn = StreamController<bool>();

  Sink<bool> get _inMusicOn => _musicOn.sink;

  Stream<bool> get musicOn => _musicOn.stream;

  final StreamController<bool> _soundOn = StreamController<bool>();

  Sink<bool> get _inSoundOn => _soundOn.sink;

  Stream<bool> get soundOn => _soundOn.stream;

  final StreamController<int> _numberOfPieces = StreamController<int>();

  Sink<int> get _inNumberOfPieces => _numberOfPieces.sink;

  Stream<int> get numberOfPieces => _numberOfPieces.stream;

  final StreamController<int> _numberOfPermutations = StreamController<int>();

  Sink<int> get _inNumberOfPermutations => _numberOfPermutations.sink;

  Stream<int> get numberOfPermutations => _numberOfPermutations.stream;

  final StreamController<bool> _piecesTurningOn = StreamController<bool>();

  Sink<bool> get _inPiecesTurningOn => _piecesTurningOn.sink;

  Stream<bool> get piecesTurningOn => _piecesTurningOn.stream;

  late final SettingsRepository _repository;

  /// Loads an initial settings
  Future<void> loadSettings() async {
    _repository = SettingsRepository();
    await _repository.init();

    _inMusicOn.add(_repository.getMusicOn());
    _inSoundOn.add(_repository.getSoundOn());
    _inNumberOfPieces.add(_repository.getNumberOfPieces());
    _inNumberOfPermutations.add(_repository.getNumberOfPermutations());
    _inPiecesTurningOn.add(_repository.getPiecesTurningOn());
  }

  void setMusicOn(bool value) {
    _repository.setMusicOn(value);
    _inMusicOn.add(value);
  }

  void setSoundOn(bool value) {
    _repository.setSoundOn(value);
    _inSoundOn.add(value);
  }

  void setNumberOfPieces(int value) {
    _inNumberOfPieces.add(_repository.setNumberOfPieces(value));
  }

  void setNumberOfPermutations(int value) {
    _inNumberOfPermutations.add(_repository.setNumberOfPermutations(value));
  }

  void setPiecesTurningOn(bool value) {
    _repository.setPiecesTurningOn(value);
    _inPiecesTurningOn.add(value);
  }

  @override
  void dispose() {
    _musicOn.close();
    _soundOn.close();
    _numberOfPieces.close();
    _numberOfPermutations.close();
    _piecesTurningOn.close();
  }
}
