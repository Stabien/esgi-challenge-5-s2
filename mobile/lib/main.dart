import 'package:flutter/material.dart';
import 'package:mobile/theme_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/layout.dart';
import 'package:mobile/eventDetail/detail_screen.dart';
import 'package:mobile/events/screen_events.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


void main() async {
  await dotenv.load();
  await dotenv.load(fileName: ".env.local");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: const Layout(),
      // home: const ScreenEvent(),
      debugShowCheckedModeBanner: false,
      theme: easyTheme,
      themeMode: ThemeMode.dark,
      routes: {
        '/': (context) => const Layout(),
      },
      onGenerateRoute: (settings) {
        final args = settings.arguments;
        switch (settings.name) {
          case '/event':
            return MaterialPageRoute(
              builder: (context) {
                return const ScreenEvent();
              },
            );
          case '/event/detail':
            return MaterialPageRoute(
              builder: (context) {
                return DetailScreen(id: args as String);
              },
            );

        }
        return null;
      }
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
      ],
    );
  }
}
