import 'package:flutter/material.dart';

import '../../core/image_loader/dto/game_field_model.dart';
import '../../view_model/game_field_view_model_user_events.dart';
import '../game_field_painter.dart';
import 'game_field_side_bar.dart';

class StatePlaying extends StatelessWidget {
  StatePlaying({
    required GameFieldViewModelUserEvents userEvents,
    required GameFieldModel model,
    required Listenable repaint,
    Key? key,
  }) : super(key: key) {
    _userEvents = userEvents;
    _model = model;
    _repaint = repaint;
  }

  late final GameFieldViewModelUserEvents _userEvents;
  late final GameFieldModel _model;
  late final Listenable _repaint;

  @override
  Widget build(BuildContext context) {
    return Row(
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
            hintButtonState: GameFieldSideBarButtonState.active,
            onHintClick: () {},
          ),
        )
      ],
    );
  }
}
