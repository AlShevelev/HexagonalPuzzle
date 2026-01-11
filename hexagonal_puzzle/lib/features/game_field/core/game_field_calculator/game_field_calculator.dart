import 'dart:ui';

import 'hexagon_measurements_calculator.dart';
import 'dto/game_field_points_dto.dart';
import 'dto/hexagon_points_dto.dart';
import 'dto/piece_points_dto.dart';

class _PriorCalculationsResult {
  _PriorCalculationsResult(this.gameFieldSize, this.hexCalculator);

  final Size gameFieldSize;
  final HexagonMeasurementsCalculator hexCalculator;
}

class GameFieldCalculator {
  /// Calculates a field size, based on a source size [maxCanvasSize] and a number of pieces in a column [pieces]
  GameFieldPointsDto calculatePieces(Size maxCanvasSize, int pieces) {
    final priorCalculations = _makePriorCalculations(maxCanvasSize, maxCanvasSize, pieces);

    final hex = priorCalculations.hexCalculator;
    final fieldSize = priorCalculations.gameFieldSize;

    return GameFieldPointsDto(
      gameFieldSize: fieldSize,
      leftTopCorner: _calculateLeftTopCorner(hex),
      rightTopCorner: _calculateRightTopCorner(fieldSize, hex),
      leftBottomCorner: _calculateLeftBottomCorner(fieldSize, hex),
      rightBottomCorner: _calculateRightBottomCorner(fieldSize, hex),
      topPieces: _calculateTopPieces(hex, pieces),
      bottomPieces: _calculateBottomPieces(fieldSize, hex, pieces),
      leftPieces: _calculateLeftPieces(hex, pieces),
      rightPieces: _calculateRightPieces(fieldSize, hex, pieces),
      hexagons: _calculateHexagons(hex, pieces),
    );
  }

  _PriorCalculationsResult _makePriorCalculations(Size sourceSize, Size draftSize, int pieces) {
    final piecesInRow = _getPiecesInRow(pieces);
    final piecesInCol = pieces;

    // the "a" value of a hexagon (see [HexagonMeasurementsCalculator] for explanation)
    final a = (draftSize.width / (piecesInRow * 2)).roundToDouble();
    final hex = HexagonMeasurementsCalculator(a);

    final gameFieldWidth = hex.width * piecesInRow;

    final smallPieces = piecesInCol ~/ 2;
    final fullPieces = piecesInCol - smallPieces;

    final gameFieldHeight = smallPieces * hex.c + fullPieces * hex.height;

    if (gameFieldWidth <= sourceSize.width && gameFieldHeight <= sourceSize.height) {
      return _PriorCalculationsResult(Size(gameFieldWidth, gameFieldHeight), hex);
    } else {
      return _makePriorCalculations(sourceSize, Size(draftSize.width * 0.99, draftSize.height * 0.99), pieces);
    }
  }

  PiecePointsDto _calculateLeftTopCorner(HexagonMeasurementsCalculator hex) {
    return PiecePointsDto(
      absoluteVertexes: [
        const Offset(0, 0),
        Offset(hex.a, 0),
        Offset(0, hex.b),
      ],
      relativeVertexes: [
        const Offset(0, 0),
        Offset(hex.a, 0),
        Offset(0, hex.b),
      ],
      rect: Rect.fromLTWH(0, 0, hex.a, hex.b),
    );
  }

  PiecePointsDto _calculateRightTopCorner(Size fieldSize, HexagonMeasurementsCalculator hex) {
    return PiecePointsDto(
      absoluteVertexes: [
        Offset(fieldSize.width - hex.a, 0),
        Offset(fieldSize.width, 0),
        Offset(fieldSize.width, hex.b),
      ],
      relativeVertexes: [
        const Offset(0, 0),
        Offset(hex.a, 0),
        Offset(hex.a, hex.b),
      ],
      rect: Rect.fromLTWH(fieldSize.width - hex.a, 0, hex.a, hex.b),
    );
  }

  PiecePointsDto _calculateLeftBottomCorner(Size fieldSize, HexagonMeasurementsCalculator hex) {
    return PiecePointsDto(
      absoluteVertexes: [
        Offset(0, fieldSize.height - hex.b),
        Offset(hex.a, fieldSize.height),
        Offset(0, fieldSize.height),
      ],
      relativeVertexes: [
        const Offset(0, 0),
        Offset(hex.a, hex.b),
        Offset(0, hex.b),
      ],
      rect: Rect.fromLTWH(0, fieldSize.height - hex.b, hex.a, hex.b),
    );
  }

  PiecePointsDto _calculateRightBottomCorner(Size fieldSize, HexagonMeasurementsCalculator hex) {
    return PiecePointsDto(
      absoluteVertexes: [
        Offset(fieldSize.width, fieldSize.height - hex.b),
        Offset(fieldSize.width, fieldSize.height),
        Offset(fieldSize.width - hex.a, fieldSize.height),
      ],
      relativeVertexes: [
        Offset(hex.a, 0),
        Offset(hex.a, hex.b),
        Offset(0, hex.b),
      ],
      rect: Rect.fromLTWH(fieldSize.width - hex.a, fieldSize.height - hex.b, hex.a, hex.b),
    );
  }

  List<PiecePointsDto> _calculateTopPieces(HexagonMeasurementsCalculator hex, int pieces) {
    final piecesInRow = _getPiecesInRow(pieces);

    final p1 = Offset(hex.a, 0);
    final p2 = Offset(p1.dx + hex.width, 0);

    final absolute = _calculateTopBottomAbsolute(
      p1,
      p2,
      Offset(p2.dx - hex.a, hex.b),
      hex,
      piecesInRow,
    );

    final relative = [
      const Offset(0, 0),
      Offset(hex.width, 0),
      Offset(hex.a, hex.b),
    ];

    final startRect = Rect.fromLTWH(p1.dx, p1.dy, hex.width, hex.b);
    final rects = _calculateTopBottomRect(startRect, hex, piecesInRow);

    return List<PiecePointsDto>.generate(absolute.length, (index) {
      return PiecePointsDto(absoluteVertexes: absolute[index], relativeVertexes: relative, rect: rects[index]);
    }, growable: false);
  }

  List<PiecePointsDto> _calculateBottomPieces(Size fieldSize, HexagonMeasurementsCalculator hex, int pieces) {
    final piecesInRow = _getPiecesInRow(pieces);

    final p1 = Offset(hex.a, fieldSize.height);
    final p2 = Offset(p1.dx + hex.width, p1.dy);

    final absolute = _calculateTopBottomAbsolute(
      p1,
      p2,
      Offset(p2.dx - hex.a, fieldSize.height - hex.b),
      hex,
      piecesInRow,
    );

    final relative = [
      Offset(0, hex.b),
      Offset(hex.width, hex.b),
      Offset(hex.a, 0),
    ];

    final startRect = Rect.fromLTWH(p1.dx, p1.dy - hex.b, hex.width, hex.b);
    final rects = _calculateTopBottomRect(startRect, hex, piecesInRow);

    return List<PiecePointsDto>.generate(absolute.length, (index) {
      return PiecePointsDto(absoluteVertexes: absolute[index], relativeVertexes: relative, rect: rects[index]);
    }, growable: false);
  }

  List<List<Offset>> _calculateTopBottomAbsolute(
    Offset p1,
    Offset p2,
    Offset p3,
    HexagonMeasurementsCalculator hex,
    int pieces,
  ) {
    return List<List<Offset>>.generate(pieces - 1, (index) {
      final offset = hex.width * index;

      return [
        p1.translate(offset, 0),
        p2.translate(offset, 0),
        p3.translate(offset, 0),
      ];
    }, growable: false);
  }

  List<Rect> _calculateTopBottomRect(Rect startRect, HexagonMeasurementsCalculator hex, int pieces) {
    return List<Rect>.generate(pieces - 1, (index) {
      final offset = hex.width * index;

      return startRect.translate(offset, 0);
    }, growable: false);
  }

  List<PiecePointsDto> _calculateLeftPieces(HexagonMeasurementsCalculator hex, int pieces) {
    final p1 = Offset(0, hex.b + hex.c);
    final p2 = Offset(p1.dx + hex.a, p1.dy + hex.b);

    final absolute = _calculateLeftRightAbsolute(
      p1,
      p2,
      Offset(p2.dx, p2.dy + hex.c),
      Offset(0, p1.dy + hex.height),
      hex,
      pieces,
    );

    final relative = [
      const Offset(0, 0),
      Offset(hex.a, hex.b),
      Offset(hex.a, hex.b + hex.c),
      Offset(0, hex.height),
    ];

    final startRect = Rect.fromLTWH(0, p1.dy, hex.a, hex.height);
    final rects = _calculateLeftRightRect(startRect, hex, pieces);

    return List<PiecePointsDto>.generate(absolute.length, (index) {
      return PiecePointsDto(absoluteVertexes: absolute[index], relativeVertexes: relative, rect: rects[index]);
    }, growable: false);
  }

  List<PiecePointsDto> _calculateRightPieces(Size fieldSize, HexagonMeasurementsCalculator hex, int pieces) {
    final p1 = Offset(fieldSize.width, hex.b + hex.c);
    final p2 = Offset(p1.dx, p1.dy + hex.height);

    final absolute = _calculateLeftRightAbsolute(
      p1,
      p2,
      Offset(p2.dx - hex.a, p2.dy - hex.b),
      Offset(p1.dx - hex.a, p1.dy + hex.b),
      hex,
      pieces,
    );

    final relative = [
      Offset(hex.a, 0),
      Offset(hex.a, hex.height),
      Offset(0, hex.b + hex.c),
      Offset(0, hex.b),
    ];

    final startRect = Rect.fromLTWH(p1.dx - hex.a, p1.dy, hex.a, hex.height);
    final rects = _calculateLeftRightRect(startRect, hex, pieces);

    return List<PiecePointsDto>.generate(absolute.length, (index) {
      return PiecePointsDto(absoluteVertexes: absolute[index], relativeVertexes: relative, rect: rects[index]);
    }, growable: false);
  }

  List<List<Offset>> _calculateLeftRightAbsolute(
    Offset p1,
    Offset p2,
    Offset p3,
    Offset p4,
    HexagonMeasurementsCalculator hex,
    int pieces,
  ) {
    return List<List<Offset>>.generate(pieces ~/ 2, (index) {
      final offset = (hex.height + hex.c) * index;

      return [
        p1.translate(0, offset),
        p2.translate(0, offset),
        p3.translate(0, offset),
        p4.translate(0, offset),
      ];
    }, growable: false);
  }

  List<Rect> _calculateLeftRightRect(Rect startRect, HexagonMeasurementsCalculator hex, int pieces) {
    return List<Rect>.generate(pieces ~/ 2, (index) {
      final offset = (hex.height + hex.c) * index;

      return startRect.translate(0, offset);
    }, growable: false);
  }

  List<HexagonPointsDto> _calculateHexagons(HexagonMeasurementsCalculator hex, int pieces) {
    final piecesInRow = _getPiecesInRow(pieces);
    final piecesInCol = pieces;

    final p1 = Offset(0, hex.b);
    final p2 = Offset(hex.a, 0);
    final p3 = Offset(hex.width, hex.b);
    final p4 = Offset(hex.width, hex.b + hex.c);
    final p5 = Offset(hex.a, hex.height);
    final p6 = Offset(0, hex.b + hex.c);

    final center = Offset(hex.a, hex.height / 2);

    final relative = [
      p1,
      p2,
      p3,
      p4,
      p5,
      p6,
    ];

    final rect = Rect.fromLTWH(0, 0, hex.width, hex.height);

    final result = List<HexagonPointsDto>.empty(growable: true);

    for (int row = 0; row < piecesInCol; row++) {
      final yOffset = row * (hex.b + hex.c);

      final bool evenRow = row % 2 == 0;

      final double xOffsetBase = hex.width;
      final int maxCol;

      if (evenRow) {
        maxCol = piecesInRow;
      } else {
        maxCol = piecesInRow - 1;
      }

      for (int col = 0; col < maxCol; col++) {
        final double xOffset;

        if (evenRow) {
          xOffset = xOffsetBase * col;
        } else {
          xOffset = xOffsetBase * col + hex.a;
        }

        result.add(HexagonPointsDto(
          center: center.translate(xOffset, yOffset),
          points: PiecePointsDto(
            absoluteVertexes: [
              p1.translate(xOffset, yOffset),
              p2.translate(xOffset, yOffset),
              p3.translate(xOffset, yOffset),
              p4.translate(xOffset, yOffset),
              p5.translate(xOffset, yOffset),
              p6.translate(xOffset, yOffset),
            ],
            relativeVertexes: relative,
            rect: rect.translate(xOffset, yOffset),
          ),
        ));
      }
    }

    return result;
  }

  int _getPiecesInRow(int pieces) {
    return (pieces * 1.6).round();
  }
}
