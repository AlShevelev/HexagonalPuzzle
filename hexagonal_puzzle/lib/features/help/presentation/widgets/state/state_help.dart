import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/ui_kit/page/simple_page_top_bar.dart';
import '../../../../game_field/core/image_loader/dto/game_field_model.dart';
import '../painter/game_field_help_painter.dart';

class StateHelp extends StatelessWidget {
  const StateHelp({required this.model, Key? key}) : super(key: key);

  final GameFieldModel model;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
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
                Navigator.of(context).pop();
              },
            ),
          ),
          Expanded(
            child: CustomPaint(
              painter: GameFieldHelpPainter(model),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [],
              ),
            ),
          )
        ],
      ),
    );
  }
}
