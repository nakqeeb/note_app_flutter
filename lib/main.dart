// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:note_app/notifiers/auth_notifier.dart';
import 'package:note_app/notifiers/locale_notifier.dart';
import 'package:note_app/provider_setup.dart';
import 'package:note_app/screens/language/language_screen.dart';
import 'package:note_app/services/authService.dart';
import 'package:provider/provider.dart';

import 'core/l10n/l18n.dart';
import 'screens/about_us/about_us_screen.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/categories/categories_screen.dart';
import 'screens/edit_note/edit_note_screen.dart';
import 'screens/note_details/note_details_screen.dart';
import 'screens/notes_overview/notes_overview_screen.dart';
import 'screens/splash/splash_screen.dart';

void main() {
  // to prevent the landscape mode
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  LocaleNotifier localeNotifier = LocaleNotifier();

  void getCurrentLanguage() async {
    localeNotifier.setLocal = await localeNotifier.localPrefs.getLocal();
  }

  @override
  void initState() {
    getCurrentLanguage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ...provider,
        ChangeNotifierProvider(create: (_) => localeNotifier),
      ],
      child: Consumer2<AuthNotifier, LocaleNotifier>(
        builder: (ctx, auth, localeNoti, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
                primary: Colors.blueGrey[900], secondary: Colors.blueGrey),
            canvasColor: Colors.blueGrey[100],
          ),
          locale: localeNoti.locale,
          supportedLocales: L10n.all,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          home: auth.isAuth
              ? NotesOverviewScreen()
              : FutureBuilder(
                  future: AuthService.tryAutoLogin(auth),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            // NotesOverviewScreen.routeName: (ctx) => NotesOverviewScreen(),
            NoteDetailsScreen.routeName: (ctx) => NoteDetailsScreen(),
            EditNoteScreen.routeName: (ctx) => EditNoteScreen(),
            CategoriesScreen.routeName: (ctx) => CategoriesScreen(),
            AboutUsScreen.routeName: (ctx) => AboutUsScreen(),
            LanguageScreen.routeName: (ctx) => LanguageScreen(),
          },
        ),
      ),
    );
  }
}
