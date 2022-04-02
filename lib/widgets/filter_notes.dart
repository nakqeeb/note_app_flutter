import 'package:flutter/material.dart';
import 'package:note_app_flutter/providers/notes.dart';
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
    final noteData = Provider.of<Notes>(context);
    return PopupMenuButton(
      offset: Offset(100, 50),
      color: Colors.blueGrey[300],
      tooltip: 'Filter',
      onSelected: (value) {
        print(value);
        callback(true);
        if (value == 'title') {
          noteData.orderByTitle = '1';
          noteData.orderByCreatedDate = null;
          noteData.orderByUpdatedDate = null;
          if (categoryId == null) {
            noteData.fetchNotes().then((_) => callback(false));
          } else {
            noteData
                .fetchNotesByCategoryId(categoryId as String)
                .then((_) => callback(false));
          }
        } else if (value == 'createdDate') {
          noteData.orderByTitle = null;
          noteData.orderByCreatedDate = '1';
          noteData.orderByUpdatedDate = null;
          if (categoryId == null) {
            noteData.fetchNotes().then((_) => callback(false));
          } else {
            noteData
                .fetchNotesByCategoryId(categoryId as String)
                .then((_) => callback(false));
          }
        } else if (value == 'updatedDate') {
          noteData.orderByTitle = null;
          noteData.orderByCreatedDate = null;
          noteData.orderByUpdatedDate = '1';
          if (categoryId == null) {
            noteData.fetchNotes().then((_) => callback(false));
          } else {
            noteData
                .fetchNotesByCategoryId(categoryId as String)
                .then((_) => callback(false));
          }
        } else if (value == 'reset') {
          noteData.orderByTitle = null;
          noteData.orderByCreatedDate = null;
          noteData.orderByUpdatedDate = null;
          if (categoryId == null) {
            noteData.fetchNotes().then((_) => callback(false));
          } else {
            noteData
                .fetchNotesByCategoryId(categoryId as String)
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
