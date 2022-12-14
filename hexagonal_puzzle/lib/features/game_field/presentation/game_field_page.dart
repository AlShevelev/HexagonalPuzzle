import 'package:flutter/material.dart';
import 'package:hexagonal_puzzle/features/game_field/presentation/widgets/state/state_hint.dart';
import '../view_model/game_field_view_model.dart';

import '../../../core/ui_kit/page/page_background.dart';
import '../view_model/model/state.dart';
import 'widgets/state/state_completed.dart';
import 'widgets/state/state_loading.dart';
import 'widgets/state/state_playing.dart';

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
                    return StateLoading(gameFieldWidgetKey: _gameFieldWidgetKey);
                  }
                case Completed:
                  {
                    final state = value.data as Completed;
                    return StateCompleted(
                      image: state.image,
                      offset: state.offset,
                      showLabel: state.showLabel,
                    );
                  }
                case Playing:
                  {
                    final state = value.data as Playing;
                    return StatePlaying(
                      userEvents: _viewModel,
                      model: state.gameFieldModel,
                      repaint: state.repaintNotifier,
                      buttonsActive: state.buttonsActive,
                      completeness: state.completeness,
                    );
                  }
                case Hint:
                  {
                    final state = value.data as Hint;
                    return StateHint(
                      image: state.image,
                      offset: state.offset,
                      completeness: state.completeness,
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
