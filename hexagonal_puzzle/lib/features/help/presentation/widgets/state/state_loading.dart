import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/ui_kit/page/simple_page_top_bar.dart';
import '../../../../../core/ui_kit/style/typography.dart';
import '../../../../../core/ui_kit/text/stroked_text.dart';
import '../../../../game_field/presentation/widgets/painter/game_field_loader_painter.dart';

class StateLoading extends StatelessWidget {
  const StateLoading({required this.helpWidgetKey, Key? key}) : super(key: key);

  final Key helpWidgetKey;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
            child: SimplePageTopBar(
              title: tr('help_title'),
              onBackClick: () {
                // do nothing
              },
            ),
          ),
          Expanded(
            child: CustomPaint(
              key: helpWidgetKey,
              painter: GameFieldLoaderPainter(),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
                      child: StrokedText(
                        text: tr('game_field_loading_in_progress'),
                        style: AppTypography.s32w400,
                      ),
                    ),
                  ]
              ),
            ),
          )
        ],
      ),

    );
  }
}
