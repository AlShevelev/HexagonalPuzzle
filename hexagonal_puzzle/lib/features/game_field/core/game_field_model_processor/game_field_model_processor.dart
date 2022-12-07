import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../image_loader/dto/game_field_hex.dart';

import '../image_loader/dto/game_field_model.dart';
import 'repaint_notifier.dart';

class GameFieldModelProcessor {
  GameFieldModelProcessor(GameFieldModel model, RepaintNotifier repaintNotifier) {
    _model = model;
    _repaintNotifier = repaintNotifier;

    _a = _model.hexes[0].points.rect.width / 2;
  }

  late final double _a;

  int _inMotionIndex = -1;
  int _readyToExchangeIndex = -1;

  late final GameFieldModel _model;
  late final RepaintNotifier _repaintNotifier;

  void onDragStart(Offset position) {
    if (_inMotionIndex != -1) {
      return;
    }

    _inMotionIndex = _getIndexOfHitItem(position);

    if (_inMotionIndex != -1) {
      _model.hexes[_inMotionIndex] = _model.hexes[_inMotionIndex].copy(state: GameFieldHexState.inMotion);
      _repaintNotifier.repaint();
    }
  }

  void onDragging(Offset position) {
    if (_inMotionIndex == -1) {
      return;
    }

    if (_tryToMove(position)) {
      _tryToSelectReadyToExchange(position);

      _repaintNotifier.repaint();
    }
  }

  /// The result is 'true' if the level is completed
  bool onDragEnd() {
    if (_inMotionIndex == -1) {
      return false;
    }

    final movedPiece = _model.hexes[_inMotionIndex];
    if (_readyToExchangeIndex == -1) {
      // reset position
      _model.hexes[_inMotionIndex] = movedPiece.copy(
        state: GameFieldHexState.notFixed,
        inMotionPoints: movedPiece.points,
      );
    } else {
      // exchange
      final exchangingPiece = _model.hexes[_readyToExchangeIndex];

      final GameFieldHexState exchangedCellState;
      if (_model.hexes[_readyToExchangeIndex].isFixed(
        angle: movedPiece.angle,
        points: exchangingPiece.points,
        fixedCenter: movedPiece.fixedCenter,
      )) {
        exchangedCellState = GameFieldHexState.fixed;
      } else {
        exchangedCellState = GameFieldHexState.notFixed;
      }
      _model.hexes[_readyToExchangeIndex] = movedPiece.copy(
          state: exchangedCellState, points: exchangingPiece.points.copy(), inMotionPoints: exchangingPiece.points.copy());

      final GameFieldHexState inMotionCellState;
      if (_model.hexes[_inMotionIndex].isFixed(
        angle: exchangingPiece.angle,
        points: movedPiece.points,
        fixedCenter: exchangingPiece.fixedCenter,
      )) {
        inMotionCellState = GameFieldHexState.fixed;
      } else {
        inMotionCellState = GameFieldHexState.notFixed;
      }
      _model.hexes[_inMotionIndex] = exchangingPiece.copy(
          state: inMotionCellState, points: movedPiece.points.copy(), inMotionPoints: movedPiece.points.copy());
    }

    _inMotionIndex = -1;
    _readyToExchangeIndex = -1;

    _repaintNotifier.repaint();

    return _checkIsCompleted();
  }

  /// The result is 'true' if the level is completed
  bool onDoubleTap(Offset position) {
    if (_inMotionIndex != -1) {
      return false;
    }

    final hitItemIndex = _getIndexOfHitItem(position);

    if (hitItemIndex == -1) {
      return false;
    }

    final hitItem = _model.hexes[hitItemIndex];

    final GameFieldHexAngle newAngle;
    if (position.dx >= hitItem.points.center.dx) {
      newAngle = _getNextClockwiseAngle(hitItem.angle);
    } else {
      newAngle = _getNextCounterClockwiseAngle(hitItem.angle);
    }

    final GameFieldHexState state;
    if (hitItem.isFixed(angle: newAngle)) {
      state = GameFieldHexState.fixed;
    } else {
      state = GameFieldHexState.notFixed;
    }

    _model.hexes[hitItemIndex] = hitItem.copy(angle: newAngle, state: state);
    _repaintNotifier.repaint();

    return _checkIsCompleted();
  }

  double _getDistance(Offset p1, Offset p2) {
    return math.sqrt(math.pow(p1.dx - p2.dx, 2) + math.pow(p1.dy - p2.dy, 2));
  }

  int _getIndexOfHitItem(Offset point) {
    for (var i = 0; i < _model.hexes.length; i++) {
      if (!_model.hexes[i].isFixed() && _getDistance(_model.hexes[i].points.center, point) <= _a) {
        return i;
      }
    }

    return -1;
  }

  bool _tryToMove(Offset position) {
    var inMotionPoints = _model.hexes[_inMotionIndex].inMotionPoints;

    final dx = position.dx - inMotionPoints.center.dx;
    final dy = position.dy - inMotionPoints.center.dy;

    if (dx.abs() < 2 || dy.abs() < 2) {
      return false;
    }

    final newInMotionPoints = GameFieldHexPoints(
      inMotionPoints.rect.translate(dx, dy),
      inMotionPoints.vertexes.map((e) => e.translate(dx, dy)).toList(growable: false),
      inMotionPoints.center.translate(dx, dy),
    );

    _model.hexes[_inMotionIndex] = _model.hexes[_inMotionIndex].copy(inMotionPoints: newInMotionPoints);

    return true;
  }

  void _tryToSelectReadyToExchange(Offset position) {
    final newReadyToExchangeIndex = _getIndexOfHitItem(position);

    if (newReadyToExchangeIndex == -1 || newReadyToExchangeIndex == _inMotionIndex) {
      if (_readyToExchangeIndex != -1) {
        _model.hexes[_readyToExchangeIndex] = _model.hexes[_readyToExchangeIndex].copy(state: GameFieldHexState.notFixed);
        _readyToExchangeIndex = -1;
      }

      return;
    }

    if (newReadyToExchangeIndex != -1) {
      if (_readyToExchangeIndex == -1) {
        _readyToExchangeIndex = newReadyToExchangeIndex;
        _model.hexes[_readyToExchangeIndex] = _model.hexes[_readyToExchangeIndex].copy(state: GameFieldHexState.readyToExchange);

        return;
      }

      if (newReadyToExchangeIndex != _readyToExchangeIndex) {
        _model.hexes[_readyToExchangeIndex] = _model.hexes[_readyToExchangeIndex].copy(state: GameFieldHexState.notFixed);

        _readyToExchangeIndex = newReadyToExchangeIndex;
        _model.hexes[_readyToExchangeIndex] = _model.hexes[_readyToExchangeIndex].copy(state: GameFieldHexState.readyToExchange);

        return;
      }
    }
  }

  GameFieldHexAngle _getNextClockwiseAngle(GameFieldHexAngle angle) {
    switch (angle) {
      case GameFieldHexAngle.angle0:
        return GameFieldHexAngle.angle60;
      case GameFieldHexAngle.angle60:
        return GameFieldHexAngle.angle120;
      case GameFieldHexAngle.angle120:
        return GameFieldHexAngle.angle180;
      case GameFieldHexAngle.angle180:
        return GameFieldHexAngle.angle240;
      case GameFieldHexAngle.angle240:
        return GameFieldHexAngle.angle300;
      case GameFieldHexAngle.angle300:
        return GameFieldHexAngle.angle0;
    }
  }

  GameFieldHexAngle _getNextCounterClockwiseAngle(GameFieldHexAngle angle) {
    switch (angle) {
      case GameFieldHexAngle.angle0:
        return GameFieldHexAngle.angle300;
      case GameFieldHexAngle.angle300:
        return GameFieldHexAngle.angle240;
      case GameFieldHexAngle.angle240:
        return GameFieldHexAngle.angle180;
      case GameFieldHexAngle.angle180:
        return GameFieldHexAngle.angle120;
      case GameFieldHexAngle.angle120:
        return GameFieldHexAngle.angle60;
      case GameFieldHexAngle.angle60:
        return GameFieldHexAngle.angle0;
    }
  }

  bool _checkIsCompleted() {
    return !_model.hexes.any((e) => e.state != GameFieldHexState.fixed);
  }
}
