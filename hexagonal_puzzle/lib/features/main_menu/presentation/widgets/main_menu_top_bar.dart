import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import '../../../../core/data/repositories/settings/settings_repository.dart';
import '../../../../core/ui_kit/style/typography.dart';
import '../../../../core/ui_kit/text/stroked_text.dart';

class MainMenuTopBar extends StatefulWidget {
  MainMenuTopBar({
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
  State<MainMenuTopBar> createState() => _MainMenuTopBarState();
}

class _MainMenuTopBarState extends State<MainMenuTopBar> {
  bool _isGeneralSoundOn = true;

  late final SettingsRepository _repository = context.read<SettingsRepository>();

  @override
  Widget build(BuildContext context) {
    _repository.soundsOn.addListener(_onSoundSettingsUpdated);
    _repository.musicOn.addListener(_onSoundSettingsUpdated);

    final String soundButtonIcon;
    if(_isGeneralSoundOn) {
      soundButtonIcon = 'assets/icons/ic_sound_on.svg';
    } else {
      soundButtonIcon = 'assets/icons/ic_sound_off.svg';
    }

    return Row(
      children: [
        StrokedText(
          text: tr('app_title'),
          style: AppTypography.s24w400,
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            setState(() {
              _repository.setSoundOn(!_isGeneralSoundOn);
              _repository.setMusicOn(!_isGeneralSoundOn);
              _onSoundSettingsUpdated();
            });
          },
          child: SvgPicture.asset(
            soundButtonIcon,
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
              style: AppTypography.s32w400,
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

  @override
  void dispose() {
    _repository.soundsOn.removeListener(_onSoundSettingsUpdated);
    _repository.musicOn.removeListener(_onSoundSettingsUpdated);

    super.dispose();
  }

  void _onSoundSettingsUpdated() {
    setState(() {
      _isGeneralSoundOn = _repository.getSoundOn() || _repository.getMusicOn();
    });
  }
}

