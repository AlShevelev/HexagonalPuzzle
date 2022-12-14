import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hexagonal_puzzle/core/audio/sound.dart';

import '../../../core/audio/audio_controller.dart';
import '../../../core/data/repositories/levels/levels_repository.dart';
import '../../../core/data/repositories/settings/settings_repository.dart';
import '../../../core/utils/simple_stream.dart';
import '../../../core/view_model/view_model_base.dart';
import '../core/game_field_model_processor/game_field_model_processor.dart';
import '../core/game_field_model_processor/repaint_notifier.dart';
import '../core/game_field_shaker/game_field_shaker.dart';
import '../core/image_loader/dto/game_field_model.dart';
import '../core/image_loader/images_loader.dart';
import 'game_field_view_model_user_events.dart';
import 'model/state.dart';

class GameFieldViewModel extends ViewModelBase implements GameFieldViewModelUserEvents {
  GameFieldViewModel(int levelId) {
    _levelId = levelId;
  }

  late final int _levelId;

  late final SettingsRepository _settingsRepository;
  late final LevelsRepository _levelsRepository;
  late final AudioController _audioController;

  late final GameFieldModel _gameFieldModel;
  late final RepaintNotifier _repaintNotifier;
  late final GameFieldModelProcessor _gesturesProcessor;

  final SimpleStream<GameFieldState> _state = SimpleStream<GameFieldState>();

  Stream<GameFieldState> get state => _state.output;

  bool _isInitialized = false;

  void init(
    SettingsRepository settingsRepository,
    LevelsRepository levelsRepository,
    AudioController audioController,
  ) {
    if (_isInitialized) {
      return;
    }

    _state.update(Loading());

    _settingsRepository = settingsRepository;
    _levelsRepository = levelsRepository;
    _audioController = audioController;

    _repaintNotifier = RepaintNotifier();

    _isInitialized = true;
  }

  Future<void> onSizeCalculated(Size size, BuildContext context) async {
    final levelInfo = await _levelsRepository.getLevel(_levelId, context);

    final draftGameFieldModel = await ImageLoader().loadImages(
      levelInfo.asset,
      size,
      _getNumberOfPieces(),
    );

    _gameFieldModel = GameFieldShaker().shake(
      draftGameFieldModel,
      _getPermutationsCount(draftGameFieldModel.hexes.length),
      _settingsRepository.getPiecesTurningOn(),
    );

    _gesturesProcessor = GameFieldModelProcessor(_gameFieldModel, _repaintNotifier);

    _state.update(Playing(
        gameFieldModel: _gameFieldModel,
        repaintNotifier: _repaintNotifier,
        buttonsActive: true,
        completeness: _gesturesProcessor.getCompleteness()));
  }

  @override
  void dispose() {
    _audioController.stopSound();
    _state.close();
  }

  @override
  void onDoubleTap(Offset position) {
    final oldCompleteness = (_state.current as Playing).completeness;

    final completeness = _gesturesProcessor.onDoubleTap(position.translate(
      _gameFieldModel.gameFieldOffset.dx,
      _gameFieldModel.gameFieldOffset.dy,
    ));

    if (completeness == 1.0) {
      _complete();
    } else {
      _state.update((_state.current as Playing).setCompleteness(completeness));

      if(oldCompleteness != completeness) {
        _audioController.playSound(SoundType.success);
      }
    }
  }

  @override
  void onDragStart(Offset position) {
    _state.update((_state.current as Playing).setButtonsState(false));
    _gesturesProcessor.onDragStart(position.translate(_gameFieldModel.gameFieldOffset.dx, _gameFieldModel.gameFieldOffset.dy));
  }

  @override
  void onDragEnd() {
    _state.update((_state.current as Playing).setButtonsState(true));

    final oldCompleteness = (_state.current as Playing).completeness;

    final completeness = _gesturesProcessor.onDragEnd();

    if (completeness == 1.0) {
      _complete();
    } else {
      _state.update((_state.current as Playing).setCompleteness(completeness));

      if(oldCompleteness != completeness) {
        _audioController.playSound(SoundType.success);
      }
    }
  }

  @override
  void onDragging(Offset position) {
    _gesturesProcessor.onDragging(position.translate(_gameFieldModel.gameFieldOffset.dx, _gameFieldModel.gameFieldOffset.dy));
  }

  @override
  void onHintClick() {
    final GameFieldState oldState = _state.current!;

    _state.update(Hint(
      image: _gameFieldModel.gameFieldImage,
      offset: _gameFieldModel.gameFieldOffset,
      completeness: _gesturesProcessor.getCompleteness(),
    ));

    Future.delayed(const Duration(milliseconds: 2000), () async {
      _state.update(oldState);
    });
  }

  int _getNumberOfPieces() {
    switch (_settingsRepository.getNumberOfPieces()) {
      case 0:
        return 3;
      case 1:
        return 5;
      case 2:
        return 7;
      default:
        return 5;
    }
  }

  int _getPermutationsCount(int totalPieces) {
    return ((_settingsRepository.getNumberOfPermutations() + 1) * 0.2 * totalPieces).toInt();
  }

  void _complete() {
    final completedState = Completed(
      image: _gameFieldModel.gameFieldImage,
      offset: _gameFieldModel.gameFieldOffset,
      showLabel: true,
    );
    
    _audioController.playSound(SoundType.win);

    _state.update(completedState);

    _levelsRepository.markAsCompleted(_levelId);

    Future.delayed(const Duration(milliseconds: 2000), () async {
      _state.update(completedState.setLabelVisibility(false));
    });
  }
}
