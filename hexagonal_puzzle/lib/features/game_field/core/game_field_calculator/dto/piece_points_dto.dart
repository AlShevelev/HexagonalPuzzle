import 'dart:ui';

class PiecePointsDto {
  PiecePointsDto({required this.absoluteVertexes, required this.relativeVertexes, required this.rect});

  final List<Offset> absoluteVertexes;

  final List<Offset> relativeVertexes;

  final Rect rect;
}