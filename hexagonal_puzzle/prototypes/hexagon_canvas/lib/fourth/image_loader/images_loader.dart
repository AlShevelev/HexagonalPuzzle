import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bitmap/bitmap.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

import '../calculators/dto/game_field_points_dto.dart';
import '../calculators/dto/piece_points_dto.dart';
import '../calculators/game_field_calculator.dart';
import 'bitmap_utils.dart';
import 'dto/load_images_result_dto.dart';
import 'dto/loaded_images_dto.dart';

class ImageLoader {
  Future<LoadImagesResultDto> loadImages(String asset, Size canvasSize, int piecesInRow) async {
    final assetBitmap = await _loadAssetBitmap(asset);

    final gameFieldCalculator = GameFieldCalculator();
    final calculationResult = gameFieldCalculator.calculatePieces(canvasSize, piecesInRow);

    final resizedBitmap = await _resizeBitmap(assetBitmap, calculationResult.gameFieldSize);
    return await _cutAllPieces(resizedBitmap, calculationResult);
  }

  Future<Bitmap> _loadAssetBitmap(String asset) async {
    final ByteData data = await rootBundle.load(asset);
    final imageDataBuffer = Uint8List.view(data.buffer);
    return await Bitmap.fromProvider(MemoryImage(imageDataBuffer));
  }

  Future<Bitmap> _resizeBitmap(Bitmap source, Size targetSize) async {
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
  }

  Future<LoadImagesResultDto> _cutAllPieces(Bitmap source, GameFieldPointsDto points) async {
    final images = LoadedImagesDto(
        leftTopCorner: await _cutPiece(source, points.leftTopCorner),
        rightTopCorner: await _cutPiece(source, points.rightTopCorner),
        leftBottomCorner: await _cutPiece(source, points.leftBottomCorner),
        rightBottomCorner: await _cutPiece(source, points.rightBottomCorner),
        topPieces: await _cutPieces(source, points.topPieces),
        bottomPieces: await _cutPieces(source, points.bottomPieces),
        leftPieces: await _cutPieces(source, points.leftPieces),
        rightPieces: await _cutPieces(source, points.rightPieces),
        hexagons: await _cutPieces(source, points.hexagons.map((e) => e.points).toList()));

    return LoadImagesResultDto(images: images, points: points);
  }

  Future<List<ui.Image>> _cutPieces(Bitmap source, List<PiecePointsDto> points) async {
    final pieces = List<ui.Image>.empty(growable: true);

    for (int i = 0; i < points.length; i++) {
      pieces.add(await _cutPiece(source, points[i]));
    }

    return pieces;
  }

  Future<ui.Image> _cutPiece(Bitmap source, PiecePointsDto points) async {
    // Cut a small rect
    final cropRect = points.rect;

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

    Path path = Path()..addPolygon(points.relativeVertexes, true);

    canvas.clipPath(path);
    canvas.drawImage(image, const Offset(0, 0), Paint());

    var pic = pictureRecorder.endRecording();
    ui.Image img = await pic.toImage(image.width, image.height);

    return img;
  }
}
