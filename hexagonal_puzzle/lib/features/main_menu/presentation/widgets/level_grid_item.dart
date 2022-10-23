import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/ui_kit/style/typography.dart';
import '../../../../core/ui_kit/text/stroked_text.dart';

import '../../../../core/data/repositories/levels/model/level_dto.dart';
import '../../../../core/ui_kit/style/colors.dart';

class LevelGridItem extends StatelessWidget {
  LevelGridItem({
    Key? key,
    required LevelDto level,
  }) : super(key: key) {
    _level = level;
  }

  late final LevelDto _level;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            color: AppColors.white,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: AppColors.brown),
                ),
                child: Image.asset(_level.asset),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: StrokedText(
              text: _level.nameLocalizationCode.tr(),
              style: AppTypography.s14w400,
            ),
          )
        ],
      ),
    );
  }
}
