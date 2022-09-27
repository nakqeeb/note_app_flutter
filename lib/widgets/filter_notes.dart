import 'package:flutter/material.dart';
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
    final notesNotifier = Provider.of<NotesNotifier>(context);
    return PopupMenuButton(
      offset: Offset(100, 50),
      color: Colors.blueGrey[300],
      tooltip: 'Filter',
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
      itemBuilder: (_) => const [
        PopupMenuItem(
          child: Text('By Title'),
          value: 'title',
        ),
        PopupMenuItem(
          child: Text('By Created Date'),
          value: 'createdDate',
        ),
        PopupMenuItem(
          child: Text('By Updated Date'),
          value: 'updatedDate',
        ),
        PopupMenuItem(
          child: Text('Reset'),
          value: 'reset',
        ),
      ],
    );
  }
}
