import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexagonal_puzzle/core/ui_kit/style/colors.dart';

import '../../../../../core/ui_kit/style/typography.dart';
import '../../../../game_field/core/image_loader/dto/game_field_model.dart';
import '../../../../game_field/presentation/widgets/painter/game_field_painter.dart';

class GameFieldHelpPainter extends GameFieldPainter {
  GameFieldHelpPainter(GameFieldModel model) : super(model, null);

  @override
  void paintGameField(Canvas canvas, Size size) {
    super.paintGameField(canvas, size);

    _paintSwap(canvas, size);
    _paintRotateRight(canvas, size);
    _paintRotateLeft(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  void _paintSwap(Canvas canvas, Size size) {
    final swapLeftCell = model.hexes[0];
    final swapRightCell = model.hexes[3];
    _paintArrow(
      canvas,
      size,
      left: swapLeftCell.fixedCenter.translate(0, -swapLeftCell.points.rect.height / 4),
      right: swapRightCell.fixedCenter.translate(0, -swapRightCell.points.rect.height / 4),
      leftArrow: true,
      rightArrow: true,
    );

    _paintText(
      canvas,
      tr('help_swap'),
      size,
      center: Offset(
        swapLeftCell.fixedCenter.dx + ((swapRightCell.fixedCenter.dx - swapLeftCell.fixedCenter.dx) / 2),
        swapLeftCell.fixedCenter.dy,
      ),
    );
  }

  void _paintRotateRight(Canvas canvas, Size size) {
    final cell = model.hexes[4];

    final leftArrowPoint = cell.fixedCenter.translate(cell.points.rect.width / 4, 0);
    final rightArrowPoint = cell.fixedCenter.translate(cell.points.rect.width, 0);

    _paintArrow(
      canvas,
      size,
      left: leftArrowPoint,
      right: rightArrowPoint,
      leftArrow: true,
      rightArrow: false,
    );

    _paintText(
      canvas,
      tr('help_clockwise'),
      size,
      center: leftArrowPoint.translate(0, cell.points.rect.height / 3),
    );
  }

  void _paintRotateLeft(Canvas canvas, Size size) {
    final cell = model.hexes[10];

    final leftArrowPoint = cell.fixedCenter.translate(-cell.points.rect.width, 0);
    final rightArrowPoint = cell.fixedCenter.translate(-cell.points.rect.width / 4, 0);

    _paintArrow(
      canvas,
      size,
      left: leftArrowPoint,
      right: rightArrowPoint,
      leftArrow: false,
      rightArrow: true,
    );

    _paintText(
      canvas,
      tr('help_counterclockwise'),
      size,
      center: rightArrowPoint.translate(0, cell.points.rect.height / 3),
    );
  }

  void _paintArrow(
    Canvas canvas,
    Size size, {
    required Offset left,
    required Offset right,
    required bool leftArrow,
    required bool rightArrow,
  }) {
    final paint = Paint()
      ..color = AppColors.white
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    _paintArrowRaw(
      canvas,
      size,
      paint,
      left: left,
      right: right,
      leftArrow: leftArrow,
      rightArrow: rightArrow,
    );

    final paint2 = Paint()
      ..color = AppColors.brown
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    _paintArrowRaw(
      canvas,
      size,
      paint2,
      left: left,
      right: right,
      leftArrow: leftArrow,
      rightArrow: rightArrow,
    );
  }

  void _paintArrowRaw(
    Canvas canvas,
    Size size,
    Paint paint, {
    required Offset left,
    required Offset right,
    required bool leftArrow,
    required bool rightArrow,
  }) {
    canvas.drawLine(left, right, paint);

    final arrowWidth = size.width / 30;
    final arrowHeight = size.height / 30;

    if (leftArrow) {
      canvas.drawLine(left, left.translate(arrowWidth, -arrowHeight), paint);
      canvas.drawLine(left, left.translate(arrowWidth, arrowHeight), paint);
    }

    if (rightArrow) {
      canvas.drawLine(right, right.translate(-arrowWidth, -arrowHeight), paint);
      canvas.drawLine(right, right.translate(-arrowWidth, arrowHeight), paint);
    }
  }

  void _paintText(
    Canvas canvas,
    String text,
    Size size, {
    Offset? center,
    Offset? leftCenter,
    Offset? rightCenter,
  }) {
    const baseStyle = AppTypography.s18w400;

    final textStyle1 = TextStyle(
      fontFamily: baseStyle.fontFamily,
      fontSize: baseStyle.fontSize,
      fontWeight: baseStyle.fontWeight,
      decoration: TextDecoration.none,
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..color = AppColors.white,
    );

    _paintTextRaw(
      canvas,
      text,
      size,
      textStyle1,
      center: center,
      leftCenter: leftCenter,
      rightCenter: rightCenter,
    );

    final textStyle2 = TextStyle(
      fontFamily: baseStyle.fontFamily,
      fontSize: baseStyle.fontSize,
      fontWeight: baseStyle.fontWeight,
      color: AppColors.brown,
      decoration: TextDecoration.none,
    );

    _paintTextRaw(
      canvas,
      text,
      size,
      textStyle2,
      center: center,
      leftCenter: leftCenter,
      rightCenter: rightCenter,
    );
  }

  void _paintTextRaw(
    Canvas canvas,
    String text,
    Size size,
    TextStyle textStyle, {
    Offset? center,
    Offset? leftCenter,
    Offset? rightCenter,
  }) {
    final textSpan = TextSpan(text: text, style: textStyle);

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: ui.TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    final Offset offset;
    final yTrans = textPainter.height / 2;

    if (center != null) {
      final xTrans = textPainter.width / 2;
      offset = center.translate(-xTrans, -yTrans);
    } else if (leftCenter != null) {
      const xTrans = 0.0;
      offset = leftCenter.translate(-xTrans, -yTrans);
    } else if (rightCenter != null) {
      final xTrans = textPainter.width;
      offset = rightCenter.translate(-xTrans, -yTrans);
    } else {
      offset = const Offset(0, 0);
    }

    textPainter.paint(canvas, offset);
  }
}
