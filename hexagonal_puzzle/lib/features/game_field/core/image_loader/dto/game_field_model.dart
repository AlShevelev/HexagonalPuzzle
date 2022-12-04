import 'game_field_fixed_piece.dart';
import 'game_field_hex.dart';

class GameFieldModel {
  GameFieldModel(this.fixed, this.hexes);

  final List<GameFieldFixedPiece> fixed;
  final List<GameFieldHex> hexes;
}
