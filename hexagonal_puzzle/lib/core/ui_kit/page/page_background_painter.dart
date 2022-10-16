import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class PageBackgroundPainter extends CustomPainter {
  PageBackgroundPainter({required ui.Image backgroundImage}) {
    _backgroundImage = backgroundImage;
  }

  late ui.Image _backgroundImage;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImageRect(
      _backgroundImage,
      Rect.fromLTWH(0, 0, _backgroundImage.width.toDouble(), _backgroundImage.height.toDouble()),
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint(),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
