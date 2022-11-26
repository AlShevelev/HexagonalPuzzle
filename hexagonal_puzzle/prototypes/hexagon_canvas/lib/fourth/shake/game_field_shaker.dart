import 'dart:math';

import '../image_loader/dto/game_field_hex.dart';
import '../image_loader/dto/game_field_model.dart';

class GameFieldShaker {
  final _random = Random();

  GameFieldModel shake(GameFieldModel model, int shakesCount, bool rotation) {
    var counter = 0;

    while (counter < shakesCount) {
      if (_tryToShake(model, rotation)) {
        counter++;
      }
    }

    return model;
  }

  bool _tryToShake(GameFieldModel model, bool rotation) {
    final index1 = _random.nextInt(model.hexes.length);
    final index2 = _random.nextInt(model.hexes.length);

    if (index1 == index2) {
      return false;
    }

    final angle1 = _getRandomAngle(rotation);
    final angle2 = _getRandomAngle(rotation);

    final hex1Copy = model.hexes[index1].copy();

    final GameFieldHexState hex1State;
    if(model.hexes[index1].isFixed(angle: angle1, points: model.hexes[index2].points)) {
      hex1State = GameFieldHexState.fixed;
    } else{
      hex1State = GameFieldHexState.notFixed;
    }
    model.hexes[index1] = model.hexes[index1].copy(
      points: model.hexes[index2].points,
      inMotionPoints: model.hexes[index2].inMotionPoints,
      state: hex1State,
      angle: angle1
    );

    final GameFieldHexState hex2State;
    if(model.hexes[index2].isFixed(angle: angle2, points: hex1Copy.points)) {
      hex2State = GameFieldHexState.fixed;
    } else{
      hex2State = GameFieldHexState.notFixed;
    }
    model.hexes[index2] = model.hexes[index2].copy(
      points: hex1Copy.points,
      inMotionPoints: hex1Copy.inMotionPoints,
      state: hex2State,
      angle: angle2
    );

    return !model.hexes[index1].isFixed() && !model.hexes[index2].isFixed();
  }

  GameFieldHexAngle _getRandomAngle(bool rotation) {
    if (!rotation) {
      return GameFieldHexAngle.angle0;
    }

    final angleValue = _random.nextInt(6);
    switch (angleValue) {
      case 0:
        return GameFieldHexAngle.angle0;
      case 1:
        return GameFieldHexAngle.angle60;
      case 2:
        return GameFieldHexAngle.angle120;
      case 3:
        return GameFieldHexAngle.angle180;
      case 4:
        return GameFieldHexAngle.angle240;
      case 5:
        return GameFieldHexAngle.angle300;
      default:
        throw Exception("Invalid value: $angleValue");
    }
  }
}