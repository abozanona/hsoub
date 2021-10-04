import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hsoub/screens/home_screen.dart';
import 'package:hsoub/screens/login_screen.dart';
import 'package:hsoub/screens/tabs/posts_tab.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hsoub',
      theme: ThemeData(
        primarySwatch: const MaterialColor(0xFFF5602A, {
          50: Color.fromRGBO(245, 96, 42, .1),
          100: Color.fromRGBO(245, 96, 42, .2),
          200: Color.fromRGBO(245, 96, 42, .3),
          300: Color.fromRGBO(245, 96, 42, .4),
          400: Color.fromRGBO(245, 96, 42, .5),
          500: Color.fromRGBO(245, 96, 42, .6),
          600: Color.fromRGBO(245, 96, 42, .7),
          700: Color.fromRGBO(245, 96, 42, .8),
          800: Color.fromRGBO(245, 96, 42, .9),
          900: Color.fromRGBO(245, 96, 42, 1),
        }),
      ),
      // home: const LoginScreen(),
      home: const HomeScreen(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ar', 'AE')],
      locale: const Locale('ar', 'AE'),
    );
  }
}
