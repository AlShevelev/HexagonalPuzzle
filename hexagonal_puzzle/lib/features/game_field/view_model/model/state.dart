import 'dart:ui' as ui;

import '../../core/game_field_model_processor/repaint_notifier.dart';
import '../../core/image_loader/dto/game_field_model.dart';

abstract class GameFieldState {}

class Loading extends GameFieldState {}

class Playing extends GameFieldState {
  Playing({required this.gameFieldModel, required this.repaintNotifier, required this.buttonsActive});

  final GameFieldModel gameFieldModel;
  final RepaintNotifier repaintNotifier;
  final bool buttonsActive;

  Playing setButtonsState(bool active) {
    return Playing(gameFieldModel: gameFieldModel, repaintNotifier: repaintNotifier, buttonsActive: active);
  }
}

class Completed extends GameFieldState {
  Completed({required this.image, required this.offset, required this.showLabel});

  final ui.Image image;
  final ui.Offset offset;
  final bool showLabel;

  Completed setLabelVisibility(bool show) {
    return Completed(image: image, offset: offset, showLabel: show);
  }
}

class Hint extends GameFieldState {
  Hint(this.image, this.offset);

  final ui.Image image;
  final ui.Offset offset;
}

