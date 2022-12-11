import 'dart:ui';

abstract class GameFieldViewModelUserEvents {
  void onDoubleTap(Offset position);

  void onDragStart(Offset position);

  void onDragEnd();

  void onDragging(Offset position);

  void onHintClick();
}