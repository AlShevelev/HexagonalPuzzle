import 'package:flutter/material.dart';

import '../../../core/ui_kit/page/page_background.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({Key? key}) : super(key: key);

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
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