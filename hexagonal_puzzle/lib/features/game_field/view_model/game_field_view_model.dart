import 'dart:async';

import 'package:flutter/material.dart';

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

  late final GameFieldModel _gameFieldModel;
  late final RepaintNotifier _repaintNotifier;
  late final GameFieldModelProcessor _gesturesProcessor;

  final SimpleStream<GameFieldState> _state = SimpleStream<GameFieldState>();

  Stream<GameFieldState> get state => _state.output;

  Future<void> init() async {
    _state.update(Loading());

    _settingsRepository = SettingsRepository();
    await _settingsRepository.init();

    _levelsRepository = LevelsRepository();
    await _levelsRepository.init();

    _repaintNotifier = RepaintNotifier();
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

    _state.update(Playing(gameFieldModel: _gameFieldModel, repaintNotifier: _repaintNotifier, buttonsActive: true));
  }

  @override
  void dispose() {
    _state.close();
  }

  @override
  void onDoubleTap(Offset position) {
    final isCompleted = _gesturesProcessor.onDoubleTap(position.translate(
      _gameFieldModel.gameFieldOffset.dx,
      _gameFieldModel.gameFieldOffset.dy,
    ));

    if (isCompleted) {
      _state.update(Completed());
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

    final isCompleted = _gesturesProcessor.onDragEnd();

    if (isCompleted) {
      _state.update(Completed());
    }
  }

  @override
  void onDragging(Offset position) {
    _gesturesProcessor.onDragging(position.translate(_gameFieldModel.gameFieldOffset.dx, _gameFieldModel.gameFieldOffset.dy));
  }

  @override
  void onHintClick() {
    final GameFieldState oldState = _state.current!;

    _state.update(Hint(_gameFieldModel.gameFieldImage, _gameFieldModel.gameFieldOffset));

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
}
