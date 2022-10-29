import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/ui_kit/style/typography.dart';
import '../../../../core/ui_kit/text/stroked_text.dart';

class SettingsPageTopBar extends StatelessWidget {
  SettingsPageTopBar({
    required Function onBackClick,
    Key? key,
  }) : super(key: key) {
    _onBackClick = onBackClick;
  }

  late final Function _onBackClick;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: GestureDetector(
            onTap: () {
              _onBackClick();
            },
            child: SvgPicture.asset(
              'assets/icons/ic_back.svg',
              width: 30,
              height: 30,
            ),
          ),
        ),
        StrokedText(
          text: tr('settings_title'),
          style: AppTypography.s24w400,
        ),
      ],
    );
  }
}
