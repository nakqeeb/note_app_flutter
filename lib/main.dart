// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_app_flutter/providers/auth.dart';
import 'package:note_app_flutter/providers/categories.dart';
import 'package:note_app_flutter/providers/iconItems.dart';
import 'package:note_app_flutter/providers/notes.dart';
import 'package:note_app_flutter/screens/about_us_screen.dart';
import 'package:note_app_flutter/screens/auth_screen.dart';
import 'package:note_app_flutter/screens/categories_screen.dart';
import 'package:note_app_flutter/screens/edit_category_screen.dart';
import 'package:note_app_flutter/screens/edit_note_screen.dart';
import 'package:note_app_flutter/screens/note_details_screen.dart';
import 'package:note_app_flutter/screens/notes_overview_screen.dart';
import 'package:note_app_flutter/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  // to prevent the landscape mode
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProxyProvider<Auth, Notes>(
          create: (_) => Notes(null, null, []),
          update: (BuildContext ctx, auth, Notes? previousNotes) => Notes(
              auth.token,
              auth.userId,
              previousNotes == null ? [] : previousNotes.notes),
        ),
        ChangeNotifierProxyProvider<Auth, Categories>(
          create: (_) => Categories(null, null, [], []),
          update: (BuildContext ctx, auth, Categories? previousCats) =>
              Categories(
                  auth.token,
                  auth.userId,
                  previousCats == null ? [] : previousCats.cats,
                  previousCats == null ? [] : previousCats.dropDownCats),
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
    return Consumer<Auth>(
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
                future: auth.tryAutoLogin(),
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
          EditCategoryScreen.routeName: (ctx) => EditCategoryScreen(),
          AboutUsScreen.routeName: (ctx) => AboutUsScreen(),
        },
      ),
    );
  }
}
