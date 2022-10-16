import 'package:flutter/material.dart';

class GameFieldPage extends StatefulWidget {
  const GameFieldPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<GameFieldPage> createState() => _GameFieldPageState();
}

class _GameFieldPageState extends State<GameFieldPage> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.title,
    );
  }
}
