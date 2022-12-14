import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../../core/ui_kit/image/ui_image_painter.dart';
import '../game_field_side_bar.dart';

class StateHint extends StatelessWidget {
  const StateHint({
    required this.image,
    required this.offset,
    required this.completeness,
    Key? key,
  }) : super(key: key);

  final ui.Image image;
  final ui.Offset offset;
  final double completeness;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Row(
        children: [
          Expanded(
              child: CustomPaint(
            painter: UIImagePainter(image: image, offset: offset, showOverlay: true),
            child: Column(
              children: const [],
            ),
          )),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8.0, 16.0, 8.0),
            child: GameFieldSideBar(
              hintButtonState: GameFieldSideBarButtonState.disabled,
              onHintClick: () {},
              closeButtonState: GameFieldSideBarButtonState.disabled,
              onCloseClick: () {},
              completeness: completeness,
            ),
          )
        ],
      ),
    );
  }
}
