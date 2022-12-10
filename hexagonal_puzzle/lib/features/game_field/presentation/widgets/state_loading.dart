import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/ui_kit/style/typography.dart';
import '../../../../core/ui_kit/text/stroked_text.dart';
import '../game_field_loader_painter.dart';
import 'game_field_side_bar.dart';

class StateLoading extends StatelessWidget {
  const StateLoading({required this.gameFieldWidgetKey, Key? key}) : super(key: key);

  final Key gameFieldWidgetKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomPaint(
            key: gameFieldWidgetKey,
            painter: GameFieldLoaderPainter(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StrokedText(
                    text: tr('loading_in_progress'),
                    style: AppTypography.s32w400,
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8.0, 16.0, 8.0),
          child: GameFieldSideBar(
            hintButtonState: GameFieldSideBarButtonState.disabled,
            onHintClick: () {},
          ),
        )
      ],
    );
  }
}
