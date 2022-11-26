import 'package:flutter/material.dart';
import 'package:hexagon_canvas/fourth/game_field_debug_painter.dart';
import 'dart:async';

import 'game_field_painter.dart';
import 'gestures_processor/gestures_processor.dart';
import 'image_loader/dto/game_field_model.dart';
import 'image_loader/images_loader.dart';
import 'repaint_notifier.dart';
import 'shake/game_field_shaker.dart';

class CustomImageCanvas4 extends StatefulWidget {
  const CustomImageCanvas4({Key? key}) : super(key: key);

  @override
  CustomImageCanvasState createState() => CustomImageCanvasState();
}

class CustomImageCanvasState extends State<CustomImageCanvas4> {
  late final GameFieldModel _gameFieldModel;

  bool _isImagesLoaded = false;

  final GlobalKey _gameFieldWidgetKey = GlobalKey();

  late final RepaintNotifier _repaintNotifier;

  late final GesturesProcessor _gesturesProcessor;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    Future.delayed(const Duration(milliseconds: 500), () async {
      final RenderBox renderBox = _gameFieldWidgetKey.currentContext?.findRenderObject() as RenderBox;

      final draftGameFieldModel = await ImageLoader().loadImages('assets/images/4.webp', renderBox.size, 7);
      _gameFieldModel = GameFieldShaker().shake(draftGameFieldModel, 15, true);

      _repaintNotifier = RepaintNotifier();

      _gesturesProcessor = GesturesProcessor(_gameFieldModel, _repaintNotifier);

      setState(() {
        _isImagesLoaded = true;
      });
    });
  }

  Widget _buildImage() {
    if (_isImagesLoaded) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onDoubleTapDown: (TapDownDetails details) {
            _gesturesProcessor.onDoubleTap(details.localPosition);
          },
          onDoubleTap: () {
            // onDoubleTapDown() is not called if this method is not overridden
          },
          onPanStart: (DragStartDetails details) {
            _gesturesProcessor.onDragStart(details.localPosition);
          },
          onPanEnd: (DragEndDetails details) {
            _gesturesProcessor.onDragEnd();
          },
          onPanUpdate: (DragUpdateDetails details) {
            _gesturesProcessor.onDragging(details.localPosition);
          },
          child: CustomPaint(
            painter: GameFieldPainter(_gameFieldModel, _repaintNotifier),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[],
              ),
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
