import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:hexagonal_puzzle/core/audio/music_track.dart';
import 'package:hexagonal_puzzle/core/audio/sound.dart';
import 'package:hexagonal_puzzle/core/data/repositories/settings/settings_repository.dart';

class AudioController {
  late final AudioPlayer _musicPlayer;
  late final AudioPlayer _sfxPlayer;

  late final List<MusicTrack> _tracksToPlay;
  int _activeTrack = 0;

  SettingsRepository? _settings;

  ValueNotifier<AppLifecycleState>? _lifecycleNotifier;

  AudioController() {
    _musicPlayer = AudioPlayer(playerId: 'musicPlayer');

    _sfxPlayer = AudioPlayer(playerId: 'soundPlayer')
      ..setAudioContext(
        AudioContext(
          android: const AudioContextAndroid(audioFocus: AndroidAudioFocus.none),
        ),
      );

    _tracksToPlay = allMusicTracks..shuffle();

    _musicPlayer.onPlayerComplete.listen(_playNextSong);
  }

  void attachLifecycleNotifier(ValueNotifier<AppLifecycleState> lifecycleNotifier) {
    _lifecycleNotifier?.removeListener(_handleAppLifecycle);

    lifecycleNotifier.addListener(_handleAppLifecycle);
    _lifecycleNotifier = lifecycleNotifier;
  }

  void attachSettings(SettingsRepository settingsRepository) {
    if (_settings == settingsRepository) {
      // Already attached to this instance. Nothing to do.
      return;
    }

    // Remove handlers from the old settings controller if present
    final oldSettings = _settings;
    if (oldSettings != null) {
      oldSettings.musicOn.removeListener(_musicOnHandler);
      oldSettings.soundsOn.removeListener(_soundsOnHandler);
    }

    _settings = settingsRepository;

    // Add handlers to the new settings controller
    settingsRepository.musicOn.addListener(_musicOnHandler);
    settingsRepository.soundsOn.addListener(_soundsOnHandler);

    if (settingsRepository.musicOn.value) {
      _startMusic();
    }
  }

  void dispose() {
    _lifecycleNotifier?.removeListener(_handleAppLifecycle);

    _stopAllSound();

    _musicPlayer.dispose();
    _sfxPlayer.dispose();
  }

  Future<void> initialize() async {
    await AudioCache.instance
        .loadAll(SoundType.values.expand(soundTypeToFilename).map((path) => 'sounds/$path').toList());
  }

  Future<void> playSound(SoundType type) async {
    final muted = _settings?.soundsOn.value == false;
    if (muted) {
      return;
    }

    final options = soundTypeToFilename(type);
    final filename = options[Random().nextInt(options.length)];

    await _sfxPlayer.play(AssetSource('sounds/$filename'));
  }

  void stopSound() {
    _sfxPlayer.stop();
  }

  void _playNextSong(void _) {
    _activeTrack++;

    if (_activeTrack == _tracksToPlay.length) {
      _activeTrack = 0;
    }

    _playSong(_activeTrack);
  }

  void _playSongWithIndex(int index) {
    _activeTrack = index;
    _playSong(_activeTrack);
  }

  Future<void> _playSong(int index) async {
    await _musicPlayer.play(AssetSource('music/${_tracksToPlay[index].filename}'));
  }

  void _handleAppLifecycle() {
    switch (_lifecycleNotifier!.value) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _stopAllSound();
        break;
      case AppLifecycleState.resumed:
        if (_settings!.musicOn.value) {
          _resumeMusic();
        }
        break;
      case AppLifecycleState.inactive:
        // No need to react to this state change.
        break;
      case AppLifecycleState.hidden:
        // No need to react to this state change.
        break;
    }
  }

  void _musicOnHandler() {
    if (_settings!.musicOn.value) {
      _resumeMusic();
    } else {
      _stopMusic();
    }
  }

  Future<void> _resumeMusic() async {
    switch (_musicPlayer.state) {
      case PlayerState.paused:
        try {
          await _musicPlayer.resume();
        } catch (e) {
          _playSongWithIndex(0);
        }
        break;
      case PlayerState.stopped:
        _playSongWithIndex(0);
        break;
      case PlayerState.playing:
        break;
      case PlayerState.completed:
        _playSongWithIndex(0);
        break;
      case PlayerState.disposed:
        break;
    }
  }

  void _soundsOnHandler() {
    if (_sfxPlayer.state == PlayerState.playing) {
      _sfxPlayer.stop();
    }
  }

  void _startMusic() {
    _playSongWithIndex(0);
  }

  void _stopAllSound() {
    if (_musicPlayer.state == PlayerState.playing) {
      _musicPlayer.pause();
    }

    _sfxPlayer.stop();
  }

  void _stopMusic() {
    if (_musicPlayer.state == PlayerState.playing) {
      _musicPlayer.pause();
    }
  }
}
