import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

import 'key_data_storage.dart';

class PngImagePainter extends CustomPainter {
  PngImagePainter(
    this.backgroundImage,
    this.pieces,
    this.keyDataStorage,
    Listenable repaint,
  ) : super(repaint: repaint);

  ui.Image backgroundImage;
  List<ui.Image?> pieces;
  KeyDataStorage keyDataStorage;

  @override
  void paint(Canvas canvas, Size size) {
    keyDataStorage.recalculate(size);

    // Background image
    final backgroundImageRect = keyDataStorage.backgroundImageRect;

    canvas.drawImageRect(
      backgroundImage,
      Rect.fromLTWH(0, 0, backgroundImage.width.toDouble(), backgroundImage.height.toDouble()),
      backgroundImageRect,
      Paint(),
    );

    // Circle stroke
    final paintCircle = Paint()
      ..color = Colors.lightGreenAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final paintImage = Paint();

    final sourceImageRect = Rect.fromLTWH(0, 0, pieces[0]!.width.toDouble(), pieces[0]!.height.toDouble());

    for (var i = 0; i < keyDataStorage.centers.length; i++) {
      drawPiece(
        canvas: canvas,
        center: keyDataStorage.centers.elementAt(i),
        angle: keyDataStorage.angles.elementAt(i),
        image: pieces[i]!,
        paintCircle: paintCircle,
        paintImage: paintImage,
        sourceImageRect: sourceImageRect
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  void drawPiece({
    required Canvas canvas,
    required Offset center,
    required double angle,
    required ui.Image image,
    required Paint paintCircle,
    required Paint paintImage,
    required Rect sourceImageRect
  }) {
    final radius = keyDataStorage.radius;

    canvas.drawCircle(center, radius, paintCircle);

    if (angle != 0) {
      canvas.save();
      canvas.translate(center.dx, center.dy);

      final rotationAngle = angle / 180.0 * math.pi;
      canvas.rotate(rotationAngle);

      canvas.drawImageRect(
        image,
        sourceImageRect,
        Rect.fromLTWH(-radius, -radius, radius * 2, radius * 2),
        paintImage,
      );

      canvas.translate(-center.dx, -center.dy);
      canvas.restore();
    } else {
      canvas.drawImageRect(
        image,
        sourceImageRect,
        Rect.fromLTWH(center.dx - radius, center.dy - radius, radius * 2, radius * 2),
        paintImage,
      );
    }
  }
}
