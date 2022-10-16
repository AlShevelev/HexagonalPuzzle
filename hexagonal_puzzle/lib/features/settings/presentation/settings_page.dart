import 'package:flutter/material.dart';

import '../../../core/ui_kit/page/page_background.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
