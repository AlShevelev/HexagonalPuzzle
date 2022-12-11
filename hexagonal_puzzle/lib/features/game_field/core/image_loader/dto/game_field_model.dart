import 'dart:ui' as ui;

import 'game_field_fixed_piece.dart';
import 'game_field_hex.dart';

class GameFieldModel {
  GameFieldModel(this.fixed, this.hexes, this.gameFieldOffset, this.gameFieldImage);

  final List<GameFieldFixedPiece> fixed;
  final List<GameFieldHex> hexes;

  final ui.Offset gameFieldOffset;
  final ui.Image gameFieldImage;
}
