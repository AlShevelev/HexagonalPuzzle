import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'calculators/dto/piece_points_dto.dart';
import 'image_loader/dto/load_images_result_dto.dart';

class GameFieldPainter extends CustomPainter {
  GameFieldPainter(LoadImagesResultDto pieces /*, Listenable repaint*/) : super(/*repaint: repaint*/) {
    _pieces = pieces;
  }

  late final LoadImagesResultDto _pieces;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    _paintPiece(canvas, _pieces.points.leftTopCorner, _pieces.images.leftTopCorner, paint);
    _paintPiece(canvas, _pieces.points.rightTopCorner, _pieces.images.rightTopCorner, paint);
    _paintPiece(canvas, _pieces.points.leftBottomCorner, _pieces.images.leftBottomCorner, paint);
    _paintPiece(canvas, _pieces.points.rightBottomCorner, _pieces.images.rightBottomCorner, paint);

    for (int i = 0; i < _pieces.points.topPieces.length; i++) {
      _paintPiece(canvas, _pieces.points.topPieces[i], _pieces.images.topPieces[i], paint);
    }

    for (int i = 0; i < _pieces.points.bottomPieces.length; i++) {
      _paintPiece(canvas, _pieces.points.bottomPieces[i], _pieces.images.bottomPieces[i], paint);
    }

    for (int i = 0; i < _pieces.points.leftPieces.length; i++) {
      _paintPiece(canvas, _pieces.points.leftPieces[i], _pieces.images.leftPieces[i], paint);
    }

    for (int i = 0; i < _pieces.points.rightPieces.length; i++) {
      _paintPiece(canvas, _pieces.points.rightPieces[i], _pieces.images.rightPieces[i], paint);
    }

    for (int i = 0; i < _pieces.points.hexagons.length; i++) {
      _paintPiece(canvas, _pieces.points.hexagons[i].points, _pieces.images.hexagons[i], paint, stroke: true);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  void _paintPiece(Canvas canvas, PiecePointsDto points, ui.Image image, Paint paint, {bool stroke = false}) {
    final Rect destRect = points.rect;
    final Rect srcRect = Rect.fromLTWH(0, 0, destRect.width, destRect.height);

    canvas.drawImageRect(
      image,
      srcRect,
      destRect,
      paint,
    );

    if(stroke) {
      final path = Path()..addPolygon(points.absoluteVertexes, true);
      final paint = Paint()
        ..color = Colors.lightGreenAccent
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;

      canvas.drawPath(path, paint);
    }
  }
}
