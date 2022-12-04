import 'dart:ui' as ui;
import 'dart:ui';

class GameFieldHex {
  GameFieldHex({
    required this.images,
    required this.points,
    required this.inMotionPoints,
    required this.angle,
    required this.fixedCenter,
    required this.state,
  });

  final Map<GameFieldHexAngle, ui.Image> images;
  final GameFieldHexPoints points;
  final GameFieldHexPoints inMotionPoints;
  final GameFieldHexAngle angle;
  final Offset fixedCenter;
  final GameFieldHexState state;

  GameFieldHex copy({
    Map<GameFieldHexAngle, ui.Image>? images,
    GameFieldHexPoints? points,
    GameFieldHexPoints? inMotionPoints,
    GameFieldHexAngle? angle,
    Offset? fixedCenter,
    GameFieldHexState? state,
  }) {
    return GameFieldHex(
      images: images ?? this.images,
      points: points ?? this.points.copy(),
      inMotionPoints: inMotionPoints ?? this.inMotionPoints.copy(),
      angle: angle ?? this.angle,
      fixedCenter: fixedCenter ?? Offset(this.fixedCenter.dx, this.fixedCenter.dy),
      state: state ?? this.state,
    );
  }

  bool isFixed({GameFieldHexAngle? angle, GameFieldHexPoints? points, Offset? fixedCenter}) {
    return (angle ?? this.angle) == GameFieldHexAngle.angle0 &&
        (points ?? this.points).center == (fixedCenter ?? this.fixedCenter);
  }
}

class GameFieldHexPoints {
  GameFieldHexPoints(this.rect, this.vertexes, this.center);

  final ui.Rect rect;
  final List<ui.Offset> vertexes;
  final ui.Offset center;

  GameFieldHexPoints copy() {
    return GameFieldHexPoints(ui.Rect.fromLTRB(rect.left, rect.top, rect.right, rect.bottom),
        vertexes.map((e) => ui.Offset(e.dx, e.dy)).toList(growable: false), ui.Offset(center.dx, center.dy));
  }
}

enum GameFieldHexAngle {
  angle0,
  angle60,
  angle120,
  angle180,
  angle240,
  angle300,
}

enum GameFieldHexState {
  notFixed,
  fixed,
  inMotion,
  readyToExchange,
}
