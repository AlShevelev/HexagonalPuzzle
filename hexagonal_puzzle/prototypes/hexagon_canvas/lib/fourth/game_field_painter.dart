import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'image_loader/dto/game_field_hex.dart';
import 'image_loader/dto/game_field_model.dart';

class GameFieldPainter extends CustomPainter {
  GameFieldPainter(GameFieldModel model, Listenable repaint) : super(repaint: repaint) {
    _model = model;

    _inMotionHexPaint = Paint()
      ..color = Colors.yellowAccent.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    _notFixedHexPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    _readyToExchangeHexPaint = Paint()
      ..color = Colors.redAccent.withOpacity(0.5)
      ..style = PaintingStyle.fill;
  }

  late final GameFieldModel _model;

  late final Paint _inMotionHexPaint;
  late final Paint _notFixedHexPaint;
  late final Paint _readyToExchangeHexPaint;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (var item in _model.fixed) {
      _paintPiece(canvas, item.rect, item.image, paint);
    }

    GameFieldHex? inMotionHex;
    for (var item in _model.hexes) {
      if(item.state == GameFieldHexState.inMotion) {
        inMotionHex = item;
      } else {
        _paintHex(canvas, item, paint);
      }
    }

    if(inMotionHex != null) {
      _paintHex(canvas, inMotionHex, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  void _paintPiece(Canvas canvas, Rect rect, ui.Image image, Paint paint) {
    final Rect destRect = rect;
    final Rect srcRect = Rect.fromLTWH(0, 0, destRect.width, destRect.height);

    canvas.drawImageRect(
      image,
      srcRect,
      destRect,
      paint,
    );
  }

  void _paintHex(Canvas canvas, GameFieldHex hex, Paint imagePaint) {
    _paintPiece(canvas, hex.inMotionPoints.rect, hex.images[hex.angle]!, imagePaint);

    final Paint paint;

    switch(hex.state) {
      case GameFieldHexState.notFixed: {
        paint = _notFixedHexPaint;
        break;
      }

      case GameFieldHexState.inMotion: {
        paint = _inMotionHexPaint;
        break;
      }

      case GameFieldHexState.readyToExchange: {
        paint = _readyToExchangeHexPaint;
        break;
      }

      case GameFieldHexState.fixed: {
        return;
      }
    }

    final path = Path()..addPolygon(hex.inMotionPoints.vertexes, true);

    canvas.drawPath(path, paint);
  }
}
