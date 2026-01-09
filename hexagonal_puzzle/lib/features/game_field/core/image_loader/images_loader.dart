import 'dart:async';
import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:image/image.dart' as img;
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

import '../game_field_calculator/dto/game_field_points_dto.dart';
import '../game_field_calculator/dto/hexagon_points_dto.dart';
import '../game_field_calculator/dto/piece_points_dto.dart';
import '../game_field_calculator/game_field_calculator.dart';
import 'dto/game_field_fixed_piece.dart';
import 'dto/game_field_hex.dart';
import 'dto/game_field_model.dart';

class ImageLoader {
  Future<GameFieldModel> loadImages(String asset, Size canvasSize, int piecesInRow) async {
    final assetImage = await _loadAssetImage(asset);

    final gameFieldCalculator = GameFieldCalculator();
    final calculationResult = gameFieldCalculator.calculatePieces(canvasSize, piecesInRow);

    final resizedBitmap = await _resizeImage(assetImage!, calculationResult.gameFieldSize);

    final gameFieldOffset = Offset(
      (canvasSize.width - calculationResult.gameFieldSize.width) / 2,
      (canvasSize.height - calculationResult.gameFieldSize.height) / 2,
    );
    return await _cutAllPieces(resizedBitmap, calculationResult, gameFieldOffset);
  }

  Future<img.Image?> _loadAssetImage(String asset) async {
    final ByteData data = await rootBundle.load(asset);
    final imageDataBuffer = Uint8List.view(data.buffer);
    return img.decodeWebP(imageDataBuffer);
  }

  Future<img.Image> _resizeImage(img.Image source, Size targetSize) async {
    final sizeFactor = targetSize.height / source.height;
    final newSourceSize = Size(source.width * sizeFactor, targetSize.height);

    final command = img.Command()
      ..image(source)
      ..copyResize(
        width: newSourceSize.width.toInt(),
        height: newSourceSize.height.toInt(),
        interpolation: img.Interpolation.cubic,
      );

    if (newSourceSize.width > targetSize.width) {
      command.copyCrop(
        x: (newSourceSize.width - targetSize.width) ~/ 2,
        y: 0,
        width: targetSize.width.toInt(),
        height: targetSize.height.toInt(),
      );
    }

    return (await command.executeThread()).outputImage!;
  }

  Future<GameFieldModel> _cutAllPieces(
    img.Image source,
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

    final ui.Image sourceImage = await _imageToUiImage(source);

    return GameFieldModel(fixed, hexes, gameFieldOffset, sourceImage);
  }

  Future<List<GameFieldFixedPiece>> _cutFixedPieces(img.Image source, List<PiecePointsDto> points) async {
    final pieces = List<GameFieldFixedPiece>.empty(growable: true);

    for (var point in points) {
      pieces.add(GameFieldFixedPiece(
        await _cutFixedPiece(source, point.rect, point.relativeVertexes),
        point.rect,
      ));
    }

    return pieces;
  }

  Future<List<GameFieldHex>> _cutHex(img.Image source, List<HexagonPointsDto> points) async {
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

  Future<ui.Image> _cutFixedPiece(img.Image source, Rect cropRect, List<Offset> relativeVertexes) async {
    // Cut a small rect
    final cropped = _cropImage(source, cropRect);

    // Convert to dart ui.Image
    final image = await _imageToUiImage(cropped);

    // Clip path
    var pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    Path path = Path()..addPolygon(relativeVertexes, true);

    canvas.clipPath(path);
    canvas.drawImage(image, const Offset(0, 0), Paint());

    var pic = pictureRecorder.endRecording();

    ui.Image result = await pic.toImage(image.width, image.height);

    return result;
  }

  Future<Map<GameFieldHexAngle, ui.Image>> _cutHexPiece(
    img.Image source,
    Rect cropRect,
    List<Offset> relativeVertexes,
  ) async {
    // Cut a small rect
    final cropped = _cropImage(source, cropRect);

    // To image
    final ui.Image image = await _imageToUiImage(cropped);

    final result = <GameFieldHexAngle, ui.Image>{};

    for (var angle in GameFieldHexAngle.values) {
      var pictureRecorder = ui.PictureRecorder();

      final canvas = Canvas(pictureRecorder);
      final center = Offset(image.width / 2, image.height / 2);

      canvas.save();
      canvas.translate(center.dx, center.dy);

      final rotationAngle = _getAngleInRadians(angle);
      canvas.rotate(rotationAngle);

      final clipVertex =
          relativeVertexes.map((e) => e.translate(-center.dx, -center.dy)).toList(growable: false);

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

  /// From here https://github.com/brendan-duncan/image/blob/main/doc/flutter.md#convert-a-dart-image-library-image-to-a-flutter-ui-image
  Future<ui.Image> _imageToUiImage(img.Image image) async {
    if (image.format != img.Format.uint8 || image.numChannels != 4) {
      final cmd = img.Command()
        ..image(image)
        ..convert(format: img.Format.uint8, numChannels: 4);
      final rgba8 = await cmd.getImageThread();
      if (rgba8 != null) {
        image = rgba8;
      }
    }

    ui.ImmutableBuffer buffer = await
    ui.ImmutableBuffer.fromUint8List(image.toUint8List());

    ui.ImageDescriptor id = ui.ImageDescriptor.raw(
        buffer,
        height: image.height,
        width: image.width,
        pixelFormat: ui.PixelFormat.rgba8888);

    ui.Codec codec = await id.instantiateCodec(
        targetHeight: image.height,
        targetWidth: image.width);

    ui.FrameInfo fi = await codec.getNextFrame();
    ui.Image uiImage = fi.image;

    return uiImage;
  }

  img.Image _cropImage(img.Image source, Rect cropRect) => img.copyCrop(
      source,
      x: cropRect.left.toInt(),
      y: cropRect.top.toInt(),
      width: cropRect.width.toInt(),
      height: cropRect.height.toInt(),
    );
}
