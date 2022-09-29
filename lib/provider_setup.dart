import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'notifiers/auth_notifier.dart';
import 'notifiers/categories_notifier.dart';
import 'notifiers/iconItems.dart';
import 'notifiers/notes_notifier.dart';

List<SingleChildWidget> provider = [
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
];
