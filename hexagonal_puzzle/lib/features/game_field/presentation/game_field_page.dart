import 'package:flutter/material.dart';

import '../../../core/ui_kit/page/page_background.dart';

class GameFieldPage extends StatefulWidget {
  const GameFieldPage({Key? key}) : super(key: key);

  @override
  State<GameFieldPage> createState() => _GameFieldPageState();
}

class _GameFieldPageState extends State<GameFieldPage> {
  @override
  Widget build(BuildContext context) {
    return PageBackground(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[],
      ),
    );
  }
}
