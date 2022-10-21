import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

import '../../../core/ui_kit/page/page_background_painter.dart';

class PageBackground extends StatefulWidget {
  const PageBackground({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<PageBackground> createState() => _PageBackgroundState();
}

class _PageBackgroundState extends State<PageBackground> {
  late final ui.Image _background;
  bool _isBackgroundLoaded = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    final ByteData data = await rootBundle.load('assets/images/page_background.webp');
    _background = await loadImage(Uint8List.view(data.buffer));
  }

  Future<ui.Image> loadImage(Uint8List img) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      setState(() {
        _isBackgroundLoaded = true;
      });
      return completer.complete(img);
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    if(_isBackgroundLoaded) {
      return CustomPaint(
        painter: PageBackgroundPainter(backgroundImage: _background),
        child: Container(
          constraints: const BoxConstraints.expand(),
          child: widget.child,
        ),
      );
    } else {
      return Container(
        constraints: const BoxConstraints.expand(),
        child: null,
      );
    }
  }
}
