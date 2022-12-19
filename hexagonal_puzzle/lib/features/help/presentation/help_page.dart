import 'package:flutter/material.dart';

import '../../../core/ui_kit/page/page_background.dart';
import '../view_model/help_view_model.dart';
import '../view_model/model/state.dart';
import 'widgets/state/state_help.dart';
import 'widgets/state/state_loading.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  late final HelpViewModel _viewModel;

  final GlobalKey _helpWidgetKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _viewModel = HelpViewModel();
    init();
  }

  Future<void> init() async {
    await _viewModel.init();

    Future.delayed(const Duration(milliseconds: 500), () async {
      final RenderBox renderBox = _helpWidgetKey.currentContext?.findRenderObject() as RenderBox;

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
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<HelpState>(
            stream: _viewModel.state,
            builder: (context, value) {
              switch (value.data.runtimeType) {
                case Loading:
                  {
                    return StateLoading(helpWidgetKey: _helpWidgetKey);
                  }
                case Rules:
                  {
                    final state = value.data as Rules;
                    return StateHelp(
                      model: state.gameFieldModel,
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
