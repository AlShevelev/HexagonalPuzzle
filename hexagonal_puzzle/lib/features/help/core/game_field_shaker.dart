import '../../game_field/core/image_loader/dto/game_field_hex.dart';
import '../../game_field/core/image_loader/dto/game_field_model.dart';

class GameFieldShaker {
  GameFieldModel shake(GameFieldModel model) {
    _swap(model, 0, 3);
    _rotate(model, 4, GameFieldHexAngle.angle300);    // clockwise
    _rotate(model, 10, GameFieldHexAngle.angle60);    // counterclockwise

    return model;
  }

  void _swap(GameFieldModel model, int index1, int index2) {
    final hex1Copy = model.hexes[index1].copy();

    model.hexes[index1] = model.hexes[index1].copy(
      points: model.hexes[index2].points,
      inMotionPoints: model.hexes[index2].inMotionPoints,
      state: GameFieldHexState.notFixed,
      angle: GameFieldHexAngle.angle0
    );

    model.hexes[index2] = model.hexes[index2].copy(
      points: hex1Copy.points,
      inMotionPoints: hex1Copy.inMotionPoints,
      state: GameFieldHexState.notFixed,
      angle: GameFieldHexAngle.angle0
    );
  }

  void _rotate(GameFieldModel model, int index, GameFieldHexAngle angle) {
    model.hexes[index] = model.hexes[index].copy(
        points: model.hexes[index].points,
        inMotionPoints: model.hexes[index].inMotionPoints,
        state: GameFieldHexState.notFixed,
        angle: angle
    );
  }
}