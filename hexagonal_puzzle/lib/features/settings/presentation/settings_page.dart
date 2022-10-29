import 'package:flutter/material.dart';

import '../../../core/ui_kit/page/page_background.dart';
import 'widgets/settings_page_top_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return PageBackground(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SettingsPageTopBar(
              onBackClick: () {
                Navigator.of(context).pop();
              },
            ),
            Expanded(
              child: Column(

              )
            )
          ],
        ),
      ),
    );
  }
}
