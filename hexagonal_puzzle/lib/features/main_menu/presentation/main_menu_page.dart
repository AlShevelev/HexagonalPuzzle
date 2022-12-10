import 'package:flutter/material.dart';

import '../../../app/routing/routes.dart';
import '../../../core/ui_kit/page/page_background.dart';
import 'widgets/level_grid.dart';
import 'widgets/main_menu_top_bar.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({Key? key}) : super(key: key);

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  @override
  Widget build(BuildContext context) {
    return PageBackground(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MainMenuTopBar(
              onHelpClick: () {
                Navigator.of(context).pushNamed(Routes.helpPage);
              },
              onSettingsClick: () {
                Navigator.of(context).pushNamed(Routes.settingsPage);
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
                child: LevelGrid(onItemClick: (levelId) {
                  Navigator.of(context).pushNamed(Routes.gameFieldPage, arguments: levelId);
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
