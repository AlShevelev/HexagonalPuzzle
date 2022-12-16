import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/ui_kit/image/ui_image_painter.dart';
import '../../../../../core/ui_kit/style/typography.dart';
import '../../../../../core/ui_kit/text/stroked_text.dart';
import '../game_field_side_bar.dart';

class StateCompleted extends StatelessWidget {
  const StateCompleted({
    required this.image,
    required this.offset,
    required this.showLabel,
    required this.levelId,
    Key? key,
  }) : super(key: key);

  final ui.Image image;
  final ui.Offset offset;
  final bool showLabel;
  final int levelId;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(true);
        return true;
      },
      child: Row(
        children: [
          Expanded(
              child: CustomPaint(
            painter: UIImagePainter(image: image, offset: offset, showOverlay: false),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (showLabel) ...[
                  StrokedText(
                    text: tr('game_field_completed'),
                    style: AppTypography.s32w400,
                  )
                ]
              ],
            ),
          )),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8.0, 16.0, 8.0),
            child: GameFieldSideBar(
              hintButtonState: GameFieldSideBarButtonState.hidden,
              onHintClick: () {},
              closeButtonState: GameFieldSideBarButtonState.active,
              onCloseClick: () {
                Navigator.of(context).pop(true);
              },
              completeness: 1.0,
            ),
          )
        ],
      ),
    );
  }
}
