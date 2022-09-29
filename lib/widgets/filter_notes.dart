import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:note_app/notifiers/locale_notifier.dart';
import 'package:note_app/notifiers/notes_notifier.dart';
import 'package:note_app/services/notesService.dart';
import 'package:provider/provider.dart';

typedef void boolCallback(bool val);

class FilterNotes extends StatelessWidget {
  final String? categoryId;
  final boolCallback callback;
  const FilterNotes(
      {Key? key, required this.categoryId, required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    final localeNotifier = Provider.of<LocaleNotifier>(context);
    final isArabic = localeNotifier.isArabic;
    final notesNotifier = Provider.of<NotesNotifier>(context);
    return PopupMenuButton(
      offset: isArabic ? Offset(-100, 50) : Offset(100, 50),
      color: Colors.blueGrey[300],
      tooltip: appLocale!.filter,
      onSelected: (value) {
        print(value);
        callback(true);
        if (value == 'title') {
          notesNotifier.orderByTitle = '1';
          notesNotifier.orderByCreatedDate = null;
          notesNotifier.orderByUpdatedDate = null;
          if (categoryId == null) {
            NotesService.fetchNotes(notesNotifier).then((_) => callback(false));
          } else {
            NotesService.fetchNotesByCategoryId(
                    categoryId as String, notesNotifier)
                .then((_) => callback(false));
          }
        } else if (value == 'createdDate') {
          notesNotifier.orderByTitle = null;
          notesNotifier.orderByCreatedDate = '1';
          notesNotifier.orderByUpdatedDate = null;
          if (categoryId == null) {
            NotesService.fetchNotes(notesNotifier).then((_) => callback(false));
          } else {
            NotesService.fetchNotesByCategoryId(
                    categoryId as String, notesNotifier)
                .then((_) => callback(false));
          }
        } else if (value == 'updatedDate') {
          notesNotifier.orderByTitle = null;
          notesNotifier.orderByCreatedDate = null;
          notesNotifier.orderByUpdatedDate = '1';
          if (categoryId == null) {
            NotesService.fetchNotes(notesNotifier).then((_) => callback(false));
          } else {
            NotesService.fetchNotesByCategoryId(
                    categoryId as String, notesNotifier)
                .then((_) => callback(false));
          }
        } else if (value == 'reset') {
          notesNotifier.orderByTitle = null;
          notesNotifier.orderByCreatedDate = null;
          notesNotifier.orderByUpdatedDate = null;
          if (categoryId == null) {
            NotesService.fetchNotes(notesNotifier).then((_) => callback(false));
          } else {
            NotesService.fetchNotesByCategoryId(
                    categoryId as String, notesNotifier)
                .then((_) => callback(false));
          }
        }
      },
      icon: const Icon(
        Icons.filter_alt,
        size: 30,
      ),
      itemBuilder: (_) => [
        PopupMenuItem(
          child: Text(appLocale.by_title),
          value: 'title',
        ),
        PopupMenuItem(
          child: Text(appLocale.by_created_date),
          value: 'createdDate',
        ),
        PopupMenuItem(
          child: Text(appLocale.by_updated_date),
          value: 'updatedDate',
        ),
        PopupMenuItem(
          child: Text(appLocale.reset),
          value: 'reset',
        ),
      ],
    );
  }
}
