// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_app/notifiers/auth_notifier.dart';
import 'package:note_app/notifiers/categories_notifier.dart';
import 'package:note_app/notifiers/notes_notifier.dart';
import 'package:note_app/services/authService.dart';
import 'package:provider/provider.dart';

import 'notifiers/iconItems.dart';
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
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthNotifier()),
        ChangeNotifierProxyProvider<AuthNotifier, NotesNotifier>(
          create: (_) => NotesNotifier(null, []),
          update: (BuildContext ctx, auth, NotesNotifier? previousNotes) =>
              NotesNotifier(
            auth.token,
            previousNotes == null ? [] : previousNotes.notes,
          ),
        ),
        ChangeNotifierProxyProvider<AuthNotifier, CategoriesNotifier>(
          create: (_) => CategoriesNotifier(null, [], []),
          update: (BuildContext ctx, auth, CategoriesNotifier? previousCats) =>
              CategoriesNotifier(
            auth.token,
            previousCats == null ? [] : previousCats.cats,
            previousCats == null ? [] : previousCats.dropDownCats,
          ),
        ),
        ChangeNotifierProvider(create: (_) => IconItems()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(
      builder: (ctx, auth, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: Colors.blueGrey[900], secondary: Colors.blueGrey),
          canvasColor: Colors.blueGrey[100],
        ),
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
        },
      ),
    );
  }
}
