import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

class PngImagePainter extends CustomPainter {
  PngImagePainter(
    this.backgroundImage,
    this.centerImage
  );

  ui.Image backgroundImage;
  ui.Image centerImage;

  static const _drawingArea = 0.8;
  Rect? _backgroundImageRect;

  @override
  void paint(Canvas canvas, Size size) {
    final canvasDrawHeight = size.height * _drawingArea;

    final imageSize = Size(backgroundImage.width.toDouble(), backgroundImage.height.toDouble());
    final imageRect = _backgroundImageRect ?? _calculateImageRect(Size(size.width, canvasDrawHeight), imageSize);

    canvas.drawImageRect(
      backgroundImage,
      Rect.fromLTWH(0, 0, imageSize.width, imageSize.height),
      imageRect,
      Paint(),
    );
//-------------------------------------------
    Paint paintCircle = Paint()
      ..color = Colors.lightGreenAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = imageRect.center;
    final radius = imageRect.width / 4;
    canvas.drawCircle(center, radius, paintCircle);
//-------------------------------------------
    canvas.drawImageRect(
      centerImage,
      Rect.fromLTWH(0, 0, centerImage.width.toDouble(), centerImage.height.toDouble()),
      imageRect.translate(10, 10),
      //imageRect,
      Paint(),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  Rect _calculateImageRect(Size canvasSize, Size imageSize) {
    double factor = canvasSize.height / imageSize.height;

    double newImageWidth = imageSize.width * factor;

    late Rect result;

    if(newImageWidth <= canvasSize.width) {
      result = Rect.fromLTWH((canvasSize.width - newImageWidth) / 2, 0, newImageWidth, canvasSize.height);
    } else {
      result = Rect.fromLTWH(0 ,0, canvasSize.width, imageSize.height * (canvasSize.width / imageSize.width));
    }

    _backgroundImageRect = result;
    return result;
  }
}
