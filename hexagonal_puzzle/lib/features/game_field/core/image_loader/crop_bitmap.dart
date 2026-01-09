/*
import 'dart:typed_data';

import 'package:bitmap/bitmap.dart';

Future<Uint8List> cropBitmap(List source) async {
  final Uint8List sourceBitmap = source[0];
  final int sourceBitmapWidth = source[1];
  final int sourceBitmapHeight = source[2];

  final int cropRectLeft = source[3];
  final int cropRectTop = source[4];
  final int cropRectWidth = source[5];
  final int cropRectHeight = source[6];

  final Bitmap bigBitmap = Bitmap.fromHeadless(sourceBitmapWidth, sourceBitmapHeight, sourceBitmap);

  final Bitmap returnBitmap = bigBitmap.apply(
    BitmapCrop.fromLTWH(
      left: cropRectLeft,
      top: cropRectTop,
      width: cropRectWidth,
      height: cropRectHeight,
    ),
  );

  return returnBitmap.content;
}
*/
