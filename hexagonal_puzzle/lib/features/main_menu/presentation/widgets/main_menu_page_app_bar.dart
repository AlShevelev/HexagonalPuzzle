import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/ui_kit/style/typography.dart';
import '../../../../core/ui_kit/text/stroked_text.dart';

class MainMenuPageAppBar extends StatefulWidget {
  MainMenuPageAppBar({
    required Function onHelpClick,
    required Function onSettingsClick,
    Key? key,
  }) : super(key: key) {
    _onHelpClick = onHelpClick;
    _onSettingsClick = onSettingsClick;
  }

  late final Function _onHelpClick;
  late final Function _onSettingsClick;

  @override
  State<MainMenuPageAppBar> createState() => _MainMenuPageAppBarState();
}

class _MainMenuPageAppBarState extends State<MainMenuPageAppBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            //onValueChanged(value - 1);
          },
          child: SvgPicture.asset(
            'assets/icons/ic_sound_off.svg',
            width: 30,
            height: 30,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: GestureDetector(
            onTap: () {
              widget._onHelpClick();
            },
            child: const StrokedText(
              text: '?',
              style: AppTypography.s40w400,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: GestureDetector(
            onTap: () {
              widget._onSettingsClick();
            },
            child: SvgPicture.asset(
              'assets/icons/ic_settings.svg',
              width: 30,
              height: 30,
            ),
          ),
        ),
      ],
    );
  }
}
