import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexagonal_puzzle/features/game_field/presentation/game_field_loader_painter.dart';
import '../../../core/ui_kit/style/typography.dart';
import '../../../core/ui_kit/text/stroked_text.dart';
import '../view_model/game_field_view_model.dart';

import '../../../core/ui_kit/page/page_background.dart';
import '../view_model/model/state.dart';
import 'game_field_painter.dart';

class GameFieldPage extends StatefulWidget {
  const GameFieldPage({required this.levelId, Key? key}) : super(key: key);

  final int levelId;

  @override
  State<GameFieldPage> createState() => _GameFieldPageState();
}

class _GameFieldPageState extends State<GameFieldPage> {
  late final GameFieldViewModel _viewModel;

  final GlobalKey _gameFieldWidgetKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _viewModel = GameFieldViewModel(widget.levelId);
    init();
  }

  Future<void> init() async {
    await _viewModel.init();

    Future.delayed(const Duration(milliseconds: 500), () async {
      final RenderBox renderBox = _gameFieldWidgetKey.currentContext?.findRenderObject() as RenderBox;

      if (mounted) {
        await _viewModel.onSizeCalculated(renderBox.size, context);
      }
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageBackground(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 8.0),
        child: StreamBuilder<GameFieldState>(
            stream: _viewModel.state,
            builder: (context, value) {
              switch (value.data.runtimeType) {
                case Loading:
                  {
                    return CustomPaint(
                      key: _gameFieldWidgetKey,
                      painter: GameFieldLoaderPainter(),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            StrokedText(
                              text: tr('loading_in_progress'),
                              style: AppTypography.s32w400,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                case Completed:
                  {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StrokedText(
                            text: tr('completed'),
                            style: AppTypography.s32w400,
                          ),
                        ],
                      ),
                    );
                  }
                case Playing:
                  {
                    final state = value.data as Playing;
                    return GestureDetector(
                      onDoubleTapDown: (TapDownDetails details) {
                        _viewModel.onDoubleTap(details.localPosition);
                      },
                      onDoubleTap: () {
                        // onDoubleTapDown() is not called if this method is not overridden
                      },
                      onPanStart: (DragStartDetails details) {
                        _viewModel.onDragStart(details.localPosition);
                      },
                      onPanEnd: (DragEndDetails details) {
                        _viewModel.onDragEnd();
                      },
                      onPanUpdate: (DragUpdateDetails details) {
                        _viewModel.onDragging(details.localPosition);
                      },
                      child: CustomPaint(
                        painter: GameFieldPainter(state.gameFieldModel, state.repaintNotifier),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[],
                          ),
                        ),
                      ),
                    );
                  }
                default:
                  {
                    return const SizedBox.shrink();
                  }
              }
            }),
      ),
    );
  }
}
