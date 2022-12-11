import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class UIImagePainter extends CustomPainter {
  UIImagePainter(this.image, this.offset);

  final ui.Image image;
  final ui.Offset offset;

  @override
  void paint(Canvas canvas, Size size) {
    final imageRect = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());

    final drawRectHeight = size.height - offset.dy * 2;
    final drawRectWidth = (drawRectHeight / imageRect.height) * imageRect.width;
    final drawRect = Rect.fromLTWH(0, 0, drawRectWidth, drawRectHeight);

    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    canvas.drawImageRect(
      image,
      imageRect,
      drawRect,
      Paint(),
    );

    final overlayPaint = Paint()
      ..color = Colors.white.withAlpha(150);
    canvas.drawRect(drawRect, overlayPaint);

    canvas.translate(-offset.dx, -offset.dy);
    canvas.restore();
  }

  @override
  bool shouldRepaint(UIImagePainter oldDelegate) {
    return image != oldDelegate.image;
  }
}