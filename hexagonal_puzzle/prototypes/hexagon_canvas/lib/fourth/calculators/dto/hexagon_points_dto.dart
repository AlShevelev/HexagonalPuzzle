import 'dart:ui';

import 'piece_points_dto.dart';

class HexagonPointsDto {
  HexagonPointsDto({required this.points, required this.center});

  final PiecePointsDto points;

  final Offset center;
}
