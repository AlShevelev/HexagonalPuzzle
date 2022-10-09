import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:typed_data';
import 'package:tuple/tuple.dart';

import 'png_image_painter.dart';

class CustomImageCanvas2 extends StatefulWidget {
  const CustomImageCanvas2({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  CustomImageCanvasState createState() => CustomImageCanvasState();
}

class CustomImageCanvasState extends State<CustomImageCanvas2> {
  late final ui.Image _image;
  late final ui.Image _centralImage;

  bool _isImageloaded = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final ByteData data = await rootBundle.load('assets/images/1.jpg');
    _image = await _loadImage(Uint8List.view(data.buffer));
    _centralImage = await _createCentralImage(_image);

    setState(() {
      _isImageloaded = true;
    });
  }

  Future<ui.Image> _loadImage(Uint8List img) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }


  Future<ui.Image> _createCentralImage(ui.Image source) async {
    final center = Offset(source.width / 2, source.height / 2);
    final radius = source.width / 4;

    final circleRect = Rect.fromLTWH(
      center.dx - radius,
      center.dy - radius,
      radius * 2,
      radius * 2,
    );

    var pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    Path path = Path()
      ..addOval(circleRect);

    canvas.clipPath(path);
    canvas.drawImage(source, const Offset(0, 0), Paint());

    var pic = pictureRecorder.endRecording();
    ui.Image img = await pic.toImage(source.width, source.height);

    return img;
  }

  Widget _buildImage() {
    if (_isImageloaded) {
      return CustomPaint(
        painter: PngImagePainter(_image, _centralImage),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[],
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