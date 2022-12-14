import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:halfdot/screens/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (
        ColorScheme? lightDynamic,
        ColorScheme? darkDynamic,
      ) =>
          MaterialApp(
        title: 'HalfDot',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: _defaultLightColorScheme,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: _defaultDarkColorScheme,
        ),
        home: const LoginPage(),
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const <Locale>[
          Locale('en', ''),
        ],
      ),
    );
  }

  ColorScheme get _defaultLightColorScheme => ColorScheme.fromSwatch(
        primarySwatch: Colors.grey,
        brightness: Brightness.light,
      );

  ColorScheme get _defaultDarkColorScheme => ColorScheme.fromSwatch(
        primarySwatch: Colors.grey,
        brightness: Brightness.dark,
      );
}
