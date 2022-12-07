import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/ui_kit/style/typography.dart';
import '../../../../core/ui_kit/text/stroked_text.dart';

class StateCompleted extends StatelessWidget {
  const StateCompleted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StrokedText(
            text: tr('completed'),
            style: AppTypography.s32w400,
          ),
        ],
      ),
    );
  }
}