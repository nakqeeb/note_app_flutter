import 'package:flutter/foundation.dart';

import '../models/note.dart';

class NotesNotifier with ChangeNotifier {
  List<Note> _notes = [];
  final String? _authToken;
  String? _orderByTitle;
  String? _orderByCreatedDate;
  String? _orderByUpdatedDate;

  NotesNotifier(this._authToken, this._notes);

  List<Note> get notes {
    return [..._notes];
  }

  String? get authToken {
    return _authToken;
  }

  String? get orderByTitle {
    return _orderByTitle;
  }

  String? get orderByCreatedDate {
    return _orderByCreatedDate;
  }

  String? get orderByUpdatedDate {
    return _orderByUpdatedDate;
  }

  set notes(List<Note> notes) {
    _notes = notes;
    notifyListeners();
  }

  set orderByTitle(String? value) {
    _orderByTitle = value;
    notifyListeners();
  }

  set orderByCreatedDate(String? value) {
    _orderByCreatedDate = value;
    notifyListeners();
  }

  set orderByUpdatedDate(String? value) {
    _orderByUpdatedDate = value;
    notifyListeners();
  }

  addNoteToList(Note note) {
    _notes.add(note);
    notifyListeners();
  }

  updateNoteInList(Note note) {
    _notes[_notes.indexWhere((element) => element.id == note.id)] = note;
    notifyListeners();
  }

  deleteNoteFromList(String noteId, bool isDeleted) {
    // final noteIndex = _notes.indexWhere((c) => c.id == noteId);
    // _notes.removeAt(noteIndex);
    // notifyListeners();
    final existingNoteIndex = _notes.indexWhere((c) => c.id == noteId);
    Note? existingNote = _notes[existingNoteIndex];
    if (isDeleted) {
      _notes.removeAt(existingNoteIndex);
      notifyListeners();
    } else {
      _notes.insert(existingNoteIndex, existingNote);
      notifyListeners();
    }
  }
}
