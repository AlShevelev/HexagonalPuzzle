import '../../core/game_field_model_processor/repaint_notifier.dart';
import '../../core/image_loader/dto/game_field_model.dart';

abstract class GameFieldState {}

class Loading extends GameFieldState {}

class Playing extends GameFieldState {
  Playing(this.gameFieldModel, this.repaintNotifier);

  final GameFieldModel gameFieldModel;
  final RepaintNotifier repaintNotifier;
}
