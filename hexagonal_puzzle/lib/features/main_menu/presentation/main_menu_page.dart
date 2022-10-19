import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../app/routing/routes.dart';
import '../../../core/ui_kit/page/page_background.dart';
import '../../../core/ui_kit/style/typography.dart';
import '../../../core/ui_kit/text/stroked_text.dart';
import 'widgets/main_menu_page_app_bar.dart';

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                StrokedText(
                  text: AppLocalizations.of(context)!.app_title,
                  style: AppTypography.s24w400,
                ),
                const Spacer(),
                MainMenuPageAppBar(
                  onHelpClick: () {
                    Navigator.of(context).pushNamed(Routes.helpPage);
                  },
                  onSettingsClick: () {
                    Navigator.of(context).pushNamed(Routes.settingsPage);
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
