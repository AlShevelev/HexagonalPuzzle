import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum GameFieldSideBarButtonState { active, inactive, disabled, hidden }

class GameFieldSideBar extends StatelessWidget {
  GameFieldSideBar({
    required GameFieldSideBarButtonState hintButtonState,
    required Function onHintClick,
    required GameFieldSideBarButtonState closeButtonState,
    required Function onCloseClick,
    Key? key,
  }) : super(key: key) {
    _hintButtonState = hintButtonState;
    _onHintClick = onHintClick;

    _closeButtonState = closeButtonState;
    _onCloseClick = onCloseClick;
  }

  late final Function _onHintClick;
  late final GameFieldSideBarButtonState _hintButtonState;

  late final Function _onCloseClick;
  late final GameFieldSideBarButtonState _closeButtonState;

  @override
  Widget build(BuildContext context) {
    final List<Widget> buttons = List.empty(growable: true);

    _tryToAddButton(
      buttons,
      state: _closeButtonState,
      disabledIcon: 'ic_close_disabled.svg',
      enabledIcon: 'ic_close.svg',
      onClick: _onCloseClick,
    );

    _tryToAddButton(
      buttons,
      state: _hintButtonState,
      disabledIcon: 'ic_show_hint_disabled.svg',
      enabledIcon: 'ic_show_hint.svg',
      onClick: _onHintClick,
    );

    return Column(
      children: buttons,
    );
  }

  void _tryToAddButton(
    List<Widget> buttons, {
    required GameFieldSideBarButtonState state,
    required String disabledIcon,
    required String enabledIcon,
    required Function onClick,
  }) {
    if (state == GameFieldSideBarButtonState.hidden) {
      return;
    }

    final String buttonAsset =
        state == GameFieldSideBarButtonState.disabled ? 'assets/icons/$disabledIcon' : 'assets/icons/$enabledIcon';

    final button = Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0.0, 16.0),
        child: GestureDetector(
          onTap: () {
            if (state == GameFieldSideBarButtonState.active) {
              onClick();
            }
          },
          child: SvgPicture.asset(
            buttonAsset,
            width: 30,
            height: 30,
          ),
        ));

    buttons.add(button);
  }
}
