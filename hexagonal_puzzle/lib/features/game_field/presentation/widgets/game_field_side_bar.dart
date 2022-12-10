import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum GameFieldSideBarButtonState { active, inactive, disabled }

class GameFieldSideBar extends StatelessWidget {
  GameFieldSideBar({
    required GameFieldSideBarButtonState hintButtonState,
    required Function onHintClick,
    Key? key,
  }) : super(key: key) {
    _hintButtonState = hintButtonState;

    _onHintClick = onHintClick;
  }

  late final Function _onHintClick;

  late final GameFieldSideBarButtonState _hintButtonState;

  @override
  Widget build(BuildContext context) {
    final String hintButtonAsset;

    if(_hintButtonState == GameFieldSideBarButtonState.disabled) {
      hintButtonAsset = 'assets/icons/ic_show_hint_disabled.svg';
    } else {
      hintButtonAsset = 'assets/icons/ic_show_hint.svg';
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (_hintButtonState == GameFieldSideBarButtonState.active) {
              _onHintClick();
            }
          },
          child: SvgPicture.asset(
            hintButtonAsset,
            width: 30,
            height: 30,
          ),
        ),
      ],
    );
  }
}
