import 'dart:ui';

import 'game_field_fixed_piece.dart';
import 'game_field_hex.dart';

class GameFieldModel {
  GameFieldModel(this.fixed, this.hexes, this.gameFieldOffset);

  final List<GameFieldFixedPiece> fixed;
  final List<GameFieldHex> hexes;
  final Offset gameFieldOffset;
}
