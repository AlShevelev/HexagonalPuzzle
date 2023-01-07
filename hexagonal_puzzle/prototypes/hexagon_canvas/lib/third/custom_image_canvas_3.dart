import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:math' as math;

import 'key_data_storage.dart';
import 'repaint_notifier.dart';
import 'image_loader.dart';
import 'png_image_painter.dart';

class CustomImageCanvas3 extends StatefulWidget {
  const CustomImageCanvas3({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  CustomImageCanvasState createState() => CustomImageCanvasState();
}

class CustomImageCanvasState extends State<CustomImageCanvas3> {
  late final ui.Image _image;
  late final List<ui.Image?> _pieces;
  late final KeyDataStorage _keyDataStorage;

  bool _isImageLoaded = false;

  late final RepaintNotifier _repaintNotifier;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    _image = await ImageLoader.loadBackgroundImage('assets/images/1.jpg');

    _keyDataStorage = KeyDataStorage(
      backgroundImageRect: Rect.fromLTWH(0, 0, _image.width.toDouble(), _image.height.toDouble()),
      itemsInRow: 8,
    );

    _pieces = await ImageLoader.loadPieceImage('assets/images/1.jpg', _keyDataStorage);

    _repaintNotifier = RepaintNotifier();

    setState(() {
      _isImageLoaded = true;
    });
  }

  Widget _buildImage() {
    if (_isImageLoaded) {
      return GestureDetector(
        onTapDown: (TapDownDetails details) {
          final tapPos = details.localPosition;

          int? selectedCenterIndex;

          for (var i = 0; i < _keyDataStorage.centers.length; i++) {
            final center = _keyDataStorage.centers.elementAt(i);
            final distance = math.sqrt(math.pow(tapPos.dx - center.dx, 2) + math.pow(tapPos.dy - center.dy, 2));

            if (distance < _keyDataStorage.radius) {
              selectedCenterIndex = i;
              break;
            }
          }

          if (selectedCenterIndex != null) {
            _keyDataStorage.updateAngle(selectedCenterIndex);
            _repaintNotifier.repaint();
          }
        },
        child: CustomPaint(
          painter: PngImagePainter(_image, _pieces, _keyDataStorage, _repaintNotifier),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[],
            ),
          ),
        ),
      );
    } else {
      return const Center(child: Text('loading'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildImage(),
    );
  }
}
