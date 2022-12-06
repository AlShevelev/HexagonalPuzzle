import 'package:flutter/material.dart';
import '../../features/game_field/presentation/game_field_page.dart';
import '../../features/help/presentation/help_page.dart';
import '../../features/settings/presentation/settings_page.dart';
import 'slide_left_route.dart';

class Routes {
  static const mainMenuPage = '/';
  static const settingsPage = '/settings';
  static const gameFieldPage = '/game_field';
  static const helpPage = '/help';

  static PageRouteBuilder? createPageRouteBuilder(RouteSettings settings) {
    switch (settings.name) {
      case settingsPage:
        {
          return SlideLeftRoute(const SettingsPage());
        }
      case gameFieldPage:
        {
          final levelId = settings.arguments as int;
          return SlideLeftRoute(GameFieldPage(levelId: levelId));
        }
      case helpPage:
        {
          return SlideLeftRoute(const HelpPage());
        }
      default:
        {
          return null;
        }
    }
  }
}
