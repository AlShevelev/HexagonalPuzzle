import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import '../../../../../core/ui_kit/style/colors.dart';
import '../../../core/image_loader/dto/game_field_hex.dart';
import '../../../core/image_loader/dto/game_field_model.dart';


class GameFieldPainter extends CustomPainter {
  GameFieldPainter(this.model, Listenable? repaint) : super(repaint: repaint) {
    _inMotionHexPaint = Paint()
      ..color = AppColors.yellow.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    _notFixedHexPaint = Paint()
      ..color = AppColors.yellow
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    _fixedHexPaint = Paint()
      ..color = AppColors.lightGray
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    _readyToExchangeHexPaint = Paint()
      ..color = AppColors.red.withOpacity(0.5)
      ..style = PaintingStyle.fill;
  }

  late final GameFieldModel model;

  late final Paint _inMotionHexPaint;
  late final Paint _notFixedHexPaint;
  late final Paint _fixedHexPaint;
  late final Paint _readyToExchangeHexPaint;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(model.gameFieldOffset.dx, model.gameFieldOffset.dy);

    paintGameField(canvas, size);

    canvas.translate(-model.gameFieldOffset.dx, -model.gameFieldOffset.dy);
    canvas.restore();
  }

  void paintGameField(Canvas canvas, Size size) {
    final paint = Paint();

    for (var item in model.fixed) {
      _paintPiece(canvas, item.rect, item.image, paint);
    }

    _paintHexes(model.hexes, GameFieldHexState.fixed, canvas, paint);
    _paintHexes(model.hexes, GameFieldHexState.notFixed, canvas, paint);
    _paintHexes(model.hexes, GameFieldHexState.readyToExchange, canvas, paint);
    _paintHexes(model.hexes, GameFieldHexState.inMotion, canvas, paint);
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

  void _paintHexes(List<GameFieldHex> hexes, GameFieldHexState state, Canvas canvas, Paint paint) {
    for (var item in model.hexes) {
      if(item.state == state) {
        _paintHex(canvas, item, paint);
      }
    }
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
        paint = _fixedHexPaint;
        break;
      }
    }

    final path = Path()..addPolygon(hex.inMotionPoints.vertexes, true);

    canvas.drawPath(path, paint);
  }
}
