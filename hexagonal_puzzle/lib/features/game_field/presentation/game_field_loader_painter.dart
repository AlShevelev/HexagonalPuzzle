import 'package:flutter/material.dart';

class GameFieldLoaderPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    print('Canvas size is: ${size.width};${size.height}');
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
