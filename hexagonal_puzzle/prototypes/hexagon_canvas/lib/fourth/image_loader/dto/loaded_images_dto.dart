import 'dart:ui' as ui;

class LoadedImagesDto {
  LoadedImagesDto({
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

  final ui.Image leftTopCorner;
  final ui.Image rightTopCorner;
  final ui.Image leftBottomCorner;
  final ui.Image rightBottomCorner;

  final List<ui.Image> topPieces;
  final List<ui.Image> bottomPieces;
  final List<ui.Image> leftPieces;
  final List<ui.Image> rightPieces;

  final List<ui.Image> hexagons;
}
