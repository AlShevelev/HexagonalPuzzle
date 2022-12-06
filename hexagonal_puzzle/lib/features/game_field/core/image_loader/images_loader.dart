import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:bitmap/bitmap.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

import '../game_field_calculator/dto/game_field_points_dto.dart';
import '../game_field_calculator/dto/hexagon_points_dto.dart';
import '../game_field_calculator/dto/piece_points_dto.dart';
import '../game_field_calculator/game_field_calculator.dart';
import 'bitmap_utils.dart';
import 'dto/game_field_fixed_piece.dart';
import 'dto/game_field_hex.dart';
import 'dto/game_field_model.dart';

class ImageLoader {
  Future<GameFieldModel> loadImages(String asset, Size canvasSize, int piecesInRow) async {
    final assetBitmap = await _loadAssetBitmap(asset);

    final gameFieldCalculator = GameFieldCalculator();
    final calculationResult = gameFieldCalculator.calculatePieces(canvasSize, piecesInRow);

    print('Game field size: ${calculationResult.gameFieldSize.width};${calculationResult.gameFieldSize.height}');

    final resizedBitmap = await _resizeBitmap(assetBitmap, calculationResult.gameFieldSize);

    final gameFieldOffset = Offset(0, (canvasSize.height - calculationResult.gameFieldSize.height) / 2);
    return await _cutAllPieces(resizedBitmap, calculationResult, gameFieldOffset);
  }

  Future<Bitmap> _loadAssetBitmap(String asset) async {
    final ByteData data = await rootBundle.load(asset);
    final imageDataBuffer = Uint8List.view(data.buffer);
    return await Bitmap.fromProvider(MemoryImage(imageDataBuffer));
  }

  Future<Bitmap> _resizeBitmap(Bitmap source, Size targetSize) async {
    final sizeFactor = targetSize.height / source.height;
    final newSourceSize = Size(source.width * sizeFactor, targetSize.height);

    if (newSourceSize.width <= targetSize.width) {
      final resized = await compute(
        resizeBitmap,
        [
          source.content,
          source.width,
          source.height,
          targetSize.width.toInt(),
          targetSize.height.toInt(),
        ],
      );

      return Bitmap.fromHeadless(targetSize.width.toInt(), targetSize.height.toInt(), resized);
    } else {
      final resized = await compute(
        resizeBitmap,
        [
          source.content,
          source.width,
          source.height,
          newSourceSize.width.toInt(),
          newSourceSize.height.toInt(),
        ],
      );

      final cropped = await compute(
        cropBitmap,
        [
          resized,
          newSourceSize.width.toInt(),
          newSourceSize.height.toInt(),
          (newSourceSize.width - targetSize.width) ~/ 2,
          0,
          targetSize.width.toInt(),
          targetSize.height.toInt(),
        ],
      );

      return Bitmap.fromHeadless(targetSize.width.toInt(), targetSize.height.toInt(), cropped);
    }
  }

  Future<GameFieldModel> _cutAllPieces(
    Bitmap source,
    GameFieldPointsDto points,
    Offset gameFieldOffset,
  ) async {
    final fixed = List<GameFieldFixedPiece>.empty(growable: true);

    fixed.add(GameFieldFixedPiece(
      await _cutFixedPiece(source, points.leftTopCorner.rect, points.leftTopCorner.relativeVertexes),
      points.leftTopCorner.rect,
    ));
    fixed.add(GameFieldFixedPiece(
      await _cutFixedPiece(source, points.rightTopCorner.rect, points.rightTopCorner.relativeVertexes),
      points.rightTopCorner.rect,
    ));
    fixed.add(GameFieldFixedPiece(
      await _cutFixedPiece(source, points.leftBottomCorner.rect, points.leftBottomCorner.relativeVertexes),
      points.leftBottomCorner.rect,
    ));
    fixed.add(GameFieldFixedPiece(
      await _cutFixedPiece(source, points.rightBottomCorner.rect, points.rightBottomCorner.relativeVertexes),
      points.rightBottomCorner.rect,
    ));

    fixed.addAll(await _cutFixedPieces(source, points.topPieces));
    fixed.addAll(await _cutFixedPieces(source, points.bottomPieces));
    fixed.addAll(await _cutFixedPieces(source, points.leftPieces));
    fixed.addAll(await _cutFixedPieces(source, points.rightPieces));

    final hexes = await _cutHex(source, points.hexagons);

    return GameFieldModel(fixed, hexes, gameFieldOffset);
  }

  Future<List<GameFieldFixedPiece>> _cutFixedPieces(Bitmap source, List<PiecePointsDto> points) async {
    final pieces = List<GameFieldFixedPiece>.empty(growable: true);

    for (var point in points) {
      pieces.add(GameFieldFixedPiece(
        await _cutFixedPiece(source, point.rect, point.relativeVertexes),
        point.rect,
      ));
    }

    return pieces;
  }

  Future<List<GameFieldHex>> _cutHex(Bitmap source, List<HexagonPointsDto> points) async {
    final hexes = List<GameFieldHex>.empty(growable: true);

    for (var point in points) {
      final resultPoints = GameFieldHexPoints(
        point.points.rect,
        point.points.absoluteVertexes,
        point.center,
      );

      hexes.add(GameFieldHex(
        images: await _cutHexPiece(source, point.points.rect, point.points.relativeVertexes),
        points: resultPoints,
        inMotionPoints: resultPoints,
        angle: GameFieldHexAngle.angle0,
        fixedCenter: resultPoints.center,
        state: GameFieldHexState.fixed,
      ));
    }

    return hexes;
  }

  Future<ui.Image> _cutFixedPiece(Bitmap source, Rect cropRect, List<Offset> relativeVertexes) async {
    // Cut a small rect
    final converted = await compute(
      cropBitmap,
      [
        source.content,
        source.width,
        source.height,
        cropRect.left.toInt(),
        cropRect.top.toInt(),
        cropRect.width.toInt(),
        cropRect.height.toInt(),
      ],
    );

    final smallBitmap = Bitmap.fromHeadless(cropRect.width.toInt(), cropRect.height.toInt(), converted);

    // To image
    final ui.Image image = await smallBitmap.buildImage();

    // Clip path
    var pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    Path path = Path()..addPolygon(relativeVertexes, true);

    canvas.clipPath(path);
    canvas.drawImage(image, const Offset(0, 0), Paint());

    var pic = pictureRecorder.endRecording();

    ui.Image img = await pic.toImage(image.width, image.height);

    return img;
  }

  Future<Map<GameFieldHexAngle, ui.Image>> _cutHexPiece(Bitmap source, Rect cropRect, List<Offset> relativeVertexes) async {
    // Cut a small rect
    final converted = await compute(
      cropBitmap,
      [
        source.content,
        source.width,
        source.height,
        cropRect.left.toInt(),
        cropRect.top.toInt(),
        cropRect.width.toInt(),
        cropRect.height.toInt(),
      ],
    );

    final smallBitmap = Bitmap.fromHeadless(cropRect.width.toInt(), cropRect.height.toInt(), converted);

    // To image
    final ui.Image image = await smallBitmap.buildImage();

    final result = <GameFieldHexAngle, ui.Image>{};

    for (var angle in GameFieldHexAngle.values) {
      var pictureRecorder = ui.PictureRecorder();

      final canvas = Canvas(pictureRecorder);
      final center = Offset(image.width / 2, image.height / 2);

      canvas.save();
      canvas.translate(center.dx, center.dy);

      final rotationAngle = _getAngleInRadians(angle);
      canvas.rotate(rotationAngle);

      final clipVertex = relativeVertexes.map((e) => e.translate(-center.dx, -center.dy)).toList(growable: false);

      Path path = Path()..addPolygon(clipVertex, true);

      canvas.clipPath(path);
      canvas.drawImage(image, Offset(-center.dx, -center.dy), Paint());

      canvas.translate(-center.dx, -center.dy);
      canvas.restore();

      var pic = pictureRecorder.endRecording();

      ui.Image img = await pic.toImage(image.width, image.height);

      result[angle] = img;
    }

    return result;

    // Clip path
    // var pictureRecorder = ui.PictureRecorder();
    //
    // final canvas = Canvas(pictureRecorder);
    // final center = Offset(image.width / 2, image.height / 2);
    //
    // canvas.save();
    // canvas.translate(center.dx, center.dy);
    //
    // final rotationAngle = _getAngleInRadians(GameFieldHexAngle.angle120);
    // canvas.rotate(rotationAngle);
    //
    // final clipVertex = relativeVertexes.map((e) => e.translate(-center.dx, -center.dy)).toList(growable: false);
    //
    // Path path = Path()..addPolygon(clipVertex, true);
    //
    // canvas.clipPath(path);
    // canvas.drawImage(image, Offset(-center.dx, -center.dy), Paint());
    //
    // canvas.translate(-center.dx, -center.dy);
    // canvas.restore();
    //
    // var pic = pictureRecorder.endRecording();
    //
    // ui.Image img = await pic.toImage(image.width, image.height);
    //
    // return img;
  }

  double _getAngleInRadians(GameFieldHexAngle angle) {
    switch (angle) {
      case GameFieldHexAngle.angle0:
        return 0;
      case GameFieldHexAngle.angle60:
        return 1 / 3 * math.pi;
      case GameFieldHexAngle.angle120:
        return 2 / 3 * math.pi;
      case GameFieldHexAngle.angle180:
        return math.pi;
      case GameFieldHexAngle.angle240:
        return 4 / 3 * math.pi;
      case GameFieldHexAngle.angle300:
        return 5 / 3 * math.pi;
    }
  }
}
