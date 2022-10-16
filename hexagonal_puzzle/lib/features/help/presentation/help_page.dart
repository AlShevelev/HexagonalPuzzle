import 'package:flutter/material.dart';

import '../../../core/ui_kit/page/page_background.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
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
