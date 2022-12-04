
import 'package:flutter/foundation.dart';

class RepaintNotifier extends ChangeNotifier {
  void repaint() {
    notifyListeners();
  }
}
