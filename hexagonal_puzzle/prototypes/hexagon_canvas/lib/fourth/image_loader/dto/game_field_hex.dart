import 'dart:ui' as ui;

class GameFieldHex {
  GameFieldHex({
    required this.images,
    required this.points,
    required this.inMotionPoints,
    required this.angle,
    required this.state,
  });

  final Map<GameFieldHexAngle, ui.Image> images;
  final GameFieldHexPoints points;
  final GameFieldHexPoints inMotionPoints;
  final GameFieldHexAngle angle;
  final GameFieldHexState state;

  GameFieldHex copy({
    Map<GameFieldHexAngle, ui.Image>? images,
    GameFieldHexPoints? points,
    GameFieldHexPoints? inMotionPoints,
    GameFieldHexAngle? angle,
    GameFieldHexState? state,
  }) {
    return GameFieldHex(
      images: images ?? this.images,
      points: points ?? this.points.copy(),
      inMotionPoints: inMotionPoints ?? this.inMotionPoints.copy(),
      angle: angle ?? this.angle,
      state: state ?? this.state,
    );
  }
}

class GameFieldHexPoints {
  GameFieldHexPoints(this.rect, this.vertexes, this.center);

  final ui.Rect rect;
  final List<ui.Offset> vertexes;
  final ui.Offset center;

  GameFieldHexPoints copy() {
    return GameFieldHexPoints(
      ui.Rect.fromLTRB(rect.left, rect.top, rect.right, rect.bottom),
      vertexes.map((e) => ui.Offset(e.dx, e.dy)).toList(growable: false),
      ui.Offset(center.dx, center.dy)
    );
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
