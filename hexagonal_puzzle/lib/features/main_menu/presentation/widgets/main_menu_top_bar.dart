import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';

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
  late final SettingsRepository _repository;

  bool _repositorySetup = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    _repository = SettingsRepository();
    await _repository.init();

    setState(() {
      _repositorySetup = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isGeneralSoundOn = true;
    if(_repositorySetup) {
      isGeneralSoundOn = _repository.getSoundOn() || _repository.getMusicOn();
    }

    final String soundButtonIcon;
    if(isGeneralSoundOn) {
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
              _repository.setSoundOn(!isGeneralSoundOn);
              _repository.setMusicOn(!isGeneralSoundOn);
              isGeneralSoundOn = !isGeneralSoundOn;
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
}