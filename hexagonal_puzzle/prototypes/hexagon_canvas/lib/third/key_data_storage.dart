import 'dart:ui';

class KeyDataStorage {
  KeyDataStorage({required Rect backgroundImageRect, required int itemsInRow}) {
    _backgroundImageRect = backgroundImageRect;

    _centers = List<Offset>.filled(itemsInRow * itemsInRow, const Offset(0, 0));
    _angles = List<double>.filled(itemsInRow * itemsInRow, 0);

    _radius = _backgroundImageRect.width / (itemsInRow * 2);

    // Fill the centers
    for(var i = 0; i < itemsInRow; i++) {      // col
      final y = _radius * 2 * i + _radius;
      for(var j = 0; j < itemsInRow; j++) {    //  row
        final x = _radius * 2 * j + _radius;

        _centers[i * itemsInRow + j] = Offset(x, y);
      }
    }
  }

  late Rect _backgroundImageRect;
  late double _radius;
  late List<Offset> _centers;
  late List<double> _angles;

  bool _recalculated = false;

  final double _drawingArea = 0.8;

  Rect get backgroundImageRect => _backgroundImageRect;
  double get radius => _radius;
  Iterable<Offset> get centers => _centers;
  Iterable<double> get angles => _angles;

  void recalculate(Size canvasSize) {
    if (_recalculated) {
      return;
    }

    final newBackgroundImageRect = _recalculateBackgroundImageRect(
      Size(canvasSize.width, canvasSize.height * _drawingArea),
      Size(_backgroundImageRect.width, _backgroundImageRect.height),
    );

    final scaleFactor = newBackgroundImageRect.width / _backgroundImageRect.width;

    _radius = _radius * scaleFactor;

    for(var i = 0; i<_centers.length; i++) {
      _centers[i] = Offset(
        _centers[i].dx * scaleFactor + newBackgroundImageRect.left,
        _centers[i].dy * scaleFactor + newBackgroundImageRect.top,
      );
    }

    _backgroundImageRect = newBackgroundImageRect;

    _recalculated = true;
  }

  void updateAngle(int index) {
    final newAngle = _angles[index] + 30;
    if (newAngle == 360) {
      _angles[index] = 0;
    } else {
      _angles[index] = newAngle;
    }
  }

  Rect _recalculateBackgroundImageRect(Size canvasSize, Size imageSize) {
    double factor = canvasSize.height / imageSize.height;

    double newImageWidth = imageSize.width * factor;

    late Rect result;

    if (newImageWidth <= canvasSize.width) {
      result = Rect.fromLTWH((canvasSize.width - newImageWidth) / 2, 0, newImageWidth, canvasSize.height);
    } else {
      result = Rect.fromLTWH(0, 0, canvasSize.width, imageSize.height * (canvasSize.width / imageSize.width));
    }

    return result;
  }
}
