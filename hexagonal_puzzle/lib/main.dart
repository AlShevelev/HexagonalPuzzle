import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import 'app_lifecycle_observer.dart';
import 'core/audio/audio_controller.dart';
import 'core/data/repositories/levels/levels_repository.dart';
import 'core/data/repositories/settings/settings_repository.dart';
import 'core/ui_kit/style/theme.dart';
import 'features/main_menu/presentation/main_menu_page.dart';
import 'app/routing/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return AppLifecycleObserver(
      child: MultiProvider(
        providers: [
          Provider<SettingsRepository>(
            lazy: false,
            create: (context) => SettingsRepository()..init(),
          ),
          Provider<LevelsRepository>(
            lazy: false,
            create: (context) => LevelsRepository()..init(),
          ),
          ProxyProvider2<SettingsRepository, ValueNotifier<AppLifecycleState>,
              AudioController>(
            lazy: false,
            create: (context) => AudioController()..initialize(),
            update: (context, settings, lifecycleNotifier, audio) {
              if (audio == null) throw ArgumentError.notNull();
              audio.attachSettings(settings);
              audio.attachLifecycleNotifier(lifecycleNotifier);
              return audio;
            },
            dispose: (context, audio) => audio.dispose(),
          ),
        ],
        child: MaterialApp(
          title: 'Six-Sided Puzzles - Cities',
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: AppThemeFactory.defaultTheme(),
          onGenerateRoute: (settings) => Routes.createPageRouteBuilder(settings),
          home: const MainMenuPage(),
        ),
      ),
    );
  }
}
