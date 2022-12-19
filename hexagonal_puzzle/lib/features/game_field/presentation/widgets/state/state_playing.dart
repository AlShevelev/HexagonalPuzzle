import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/ui_kit/style/typography.dart';
import '../../../../../core/ui_kit/text/stroked_text.dart';
import '../../../core/image_loader/dto/game_field_model.dart';
import '../../../view_model/game_field_view_model_user_events.dart';
import '../painter/game_field_painter.dart';
import '../game_field_side_bar.dart';

class StatePlaying extends StatelessWidget {
  StatePlaying({
    required GameFieldViewModelUserEvents userEvents,
    required GameFieldModel model,
    required Listenable repaint,
    required bool buttonsActive,
    required double completeness,
    Key? key,
  }) : super(key: key) {
    _userEvents = userEvents;
    _model = model;
    _repaint = repaint;
    _buttonsActive = buttonsActive;
    _completeness = completeness;
  }

  late final GameFieldViewModelUserEvents _userEvents;
  late final GameFieldModel _model;
  late final Listenable _repaint;
  late final bool _buttonsActive;
  late final double _completeness;

  @override
  Widget build(BuildContext context) {
    final GameFieldSideBarButtonState buttonsState;
    if (_buttonsActive) {
      buttonsState = GameFieldSideBarButtonState.active;
    } else {
      buttonsState = GameFieldSideBarButtonState.disabled;
    }

    return WillPopScope(
      onWillPop: () async {
        if (!_buttonsActive) {
          return false;
        }
        if (await _onClosePopupDialog(context)) {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop(false);
          return true;
        }
        return false;
      },
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onDoubleTapDown: (TapDownDetails details) {
                _userEvents.onDoubleTap(details.localPosition);
              },
              onDoubleTap: () {
                // onDoubleTapDown() is not called if this method is not overridden
              },
              onPanStart: (DragStartDetails details) {
                _userEvents.onDragStart(details.localPosition);
              },
              onPanEnd: (DragEndDetails details) {
                _userEvents.onDragEnd();
              },
              onPanUpdate: (DragUpdateDetails details) {
                _userEvents.onDragging(details.localPosition);
              },
              child: CustomPaint(
                painter: GameFieldPainter(_model, _repaint),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8.0, 16.0, 8.0),
            child: GameFieldSideBar(
              hintButtonState: buttonsState,
              onHintClick: () {
                _userEvents.onHintClick();
              },
              closeButtonState: buttonsState,
              onCloseClick: () async {
                if (await _onClosePopupDialog(context)) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop(false);
                }
              },
              completeness: _completeness,
            ),
          )
        ],
      ),
    );
  }

  Future<bool> _onClosePopupDialog(BuildContext context) async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            backgroundColor: Colors.white.withOpacity(0.5),
            content: StrokedText(
              text: tr('game_field_interrupt_question'),
              style: AppTypography.s24w400,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: StrokedText(
                  text: tr('general_no'),
                  style: AppTypography.s24w400,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: StrokedText(
                  text: tr('general_yes'),
                  style: AppTypography.s24w400,
                ),
              ),
            ],
          ),
        )) ??
        false;
  }
}
