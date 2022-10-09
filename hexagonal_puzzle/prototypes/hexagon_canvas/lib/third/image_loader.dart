import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bitmap/bitmap.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

import 'crop_bitmap.dart';
import 'key_data_storage.dart';

class ImageLoader {
  static Future<ui.Image> loadBackgroundImage(String asset) async {
    final ByteData data = await rootBundle.load(asset);
    final imageDataBuffer = Uint8List.view(data.buffer);
    return _loadImage(imageDataBuffer);
  }

  static Future<List<ui.Image?>> loadPieceImage(String asset, KeyDataStorage keyDataStorage) async {
    final ByteData centralImageData = await rootBundle.load(asset);
    final centralImageDataBuffer = Uint8List.view(centralImageData.buffer);

    final result = List<ui.Image?>.empty(growable: true);

    for(var center in keyDataStorage.centers) {
      result.add(await _createCentralImage(centralImageDataBuffer, keyDataStorage, center));
    }

    return result;
  }

  static Future<ui.Image> _loadImage(Uint8List img) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  static Future<ui.Image> _createCentralImage(Uint8List sourceImageData, KeyDataStorage keyDataStorage, Offset center) async {
    // Crop
    final sourceBitmap = await Bitmap.fromProvider(MemoryImage(sourceImageData));

    final cropRect = Rect.fromLTWH(
      center.dx - keyDataStorage.radius,
      center.dy - keyDataStorage.radius,
      keyDataStorage.radius * 2,
      keyDataStorage.radius * 2,
    );

    final converted = await compute(
      cropBitmap,
      [
        sourceBitmap.content,
        sourceBitmap.width,
        sourceBitmap.height,
        cropRect.left.toInt(),
        cropRect.top.toInt(),
        cropRect.width.toInt(),
        cropRect.height.toInt(),
      ],
    );

    final smallBitmap = Bitmap.fromHeadless(cropRect.width.toInt(), cropRect.height.toInt(), converted);

    // To image
    final ui.Image image = await smallBitmap.buildImage();

    // Make circle
    final circleRect = Rect.fromLTWH(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );

    var pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    Path path = Path()..addOval(circleRect);

    canvas.clipPath(path);
    canvas.drawImage(image, const Offset(0, 0), Paint());

    var pic = pictureRecorder.endRecording();
    ui.Image img = await pic.toImage(image.width, image.height);

    return img;
  }
}
