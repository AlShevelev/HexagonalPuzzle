import 'package:flutter/material.dart';

import '../style/colors.dart';

/// Text with stroke
class StrokedText extends StatelessWidget {
  const StrokedText({
    Key? key,
    required this.text,
    this.textColor = AppColors.brown,
    this.strokeColor = AppColors.white,
    this.strokeWidth = 3.0,
    required this.style,
  }) : super(key: key);

  final String text;
  final Color textColor;
  final Color strokeColor;
  final double strokeWidth;
  final TextStyle style;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Stroked text as border.
        Text(
          text,
          style: TextStyle(
            fontFamily: style.fontFamily,
            fontSize: style.fontSize,
            fontWeight: style.fontWeight,
            decoration: TextDecoration.none,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor,
          ),
        ),
        // Solid text as fill.
        Text(
          text,
          style: TextStyle(
            fontFamily: style.fontFamily,
            fontSize: style.fontSize,
            fontWeight: style.fontWeight,
            color: textColor,
            decoration: TextDecoration.none,
          ),
        ),
      ],
    );
  }
}
