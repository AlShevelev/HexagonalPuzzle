import 'package:flutter/material.dart';
import 'package:hexagon_canvas/fourth/game_field_debug_painter.dart';
import 'dart:async';

import 'game_field_painter.dart';
import 'image_loader/dto/load_images_result_dto.dart';
import 'image_loader/images_loader.dart';

class CustomImageCanvas4 extends StatefulWidget {
  const CustomImageCanvas4({Key? key}) : super(key: key);

  @override
  CustomImageCanvasState createState() => CustomImageCanvasState();
}

class CustomImageCanvasState extends State<CustomImageCanvas4> {
  late final LoadImagesResultDto _images;

  bool _isImagesLoaded = false;

  final GlobalKey _gameFieldWidgetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    Future.delayed(const Duration(milliseconds: 500), () async {
      final RenderBox renderBox = _gameFieldWidgetKey.currentContext?.findRenderObject() as RenderBox;

      _images = await ImageLoader().loadImages('assets/images/3.webp', renderBox.size, 9);

      setState(() {
        _isImagesLoaded = true;
      });
    });
  }

  Widget _buildImage() {
    if (_isImagesLoaded) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomPaint(
         painter: GameFieldPainter(_images),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[],
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomPaint(
          key: _gameFieldWidgetKey,
          painter: GameFieldDebugPainter(),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: _buildImage(),
    );
  }
}
