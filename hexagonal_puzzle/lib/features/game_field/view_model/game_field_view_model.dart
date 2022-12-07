import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/data/repositories/levels/levels_repository.dart';
import '../../../core/data/repositories/settings/settings_repository.dart';
import '../../../core/view_model/view_model_base.dart';
import '../core/game_field_model_processor/game_field_model_processor.dart';
import '../core/game_field_model_processor/repaint_notifier.dart';
import '../core/game_field_shaker/game_field_shaker.dart';
import '../core/image_loader/dto/game_field_model.dart';
import '../core/image_loader/images_loader.dart';
import 'model/state.dart';

class GameFieldViewModel extends ViewModelBase {
  GameFieldViewModel(int levelId) {
    _levelId = levelId;
  }

  late final int _levelId;

  late final SettingsRepository _settingsRepository;
  late final LevelsRepository _levelsRepository;

  late final GameFieldModel _gameFieldModel;
  late final RepaintNotifier _repaintNotifier;
  late final GameFieldModelProcessor _gesturesProcessor;

  final StreamController<GameFieldState> _state = StreamController<GameFieldState>();

  Sink<GameFieldState> get _stateUpdate => _state.sink;

  Stream<GameFieldState> get state => _state.stream;

  Future<void> init() async {
    _stateUpdate.add(Loading());

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

    _stateUpdate.add(Playing(_gameFieldModel, _repaintNotifier));
  }

  @override
  void dispose() {
    _state.close();
  }

  void onDoubleTap(Offset position) {
    final isCompleted = _gesturesProcessor.onDoubleTap(position.translate(
      _gameFieldModel.gameFieldOffset.dx,
      _gameFieldModel.gameFieldOffset.dy,
    ));

    if (isCompleted) {
      _stateUpdate.add(Completed());
    }
  }

  void onDragStart(Offset position) {
    _gesturesProcessor.onDragStart(position.translate(_gameFieldModel.gameFieldOffset.dx, _gameFieldModel.gameFieldOffset.dy));
  }

  void onDragEnd() {
    final isCompleted = _gesturesProcessor.onDragEnd();

    if (isCompleted) {
      _stateUpdate.add(Completed());
    }
  }

  void onDragging(Offset position) {
    _gesturesProcessor.onDragging(position.translate(_gameFieldModel.gameFieldOffset.dx, _gameFieldModel.gameFieldOffset.dy));
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
