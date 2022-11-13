
import 'dart:ui';

import 'hexagon_points_dto.dart';
import 'piece_points_dto.dart';

class GameFieldPointsDto {
  GameFieldPointsDto({
    required this.gameFieldSize,
    required this.leftTopCorner,
    required this.rightTopCorner,
    required this.leftBottomCorner,
    required this.rightBottomCorner,
    required this.topPieces,
    required this.bottomPieces,
    required this.leftPieces,
    required this.rightPieces,
    required this.hexagons,
  });

  final Size gameFieldSize;

  final PiecePointsDto leftTopCorner;
  final PiecePointsDto rightTopCorner;
  final PiecePointsDto leftBottomCorner;
  final PiecePointsDto rightBottomCorner;

  final List<PiecePointsDto> topPieces;
  final List<PiecePointsDto> bottomPieces;
  final List<PiecePointsDto> leftPieces;
  final List<PiecePointsDto> rightPieces;

  final List<HexagonPointsDto> hexagons;
}
