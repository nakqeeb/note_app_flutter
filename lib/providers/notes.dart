import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:note_app_flutter/models/creator.dart';
import 'package:note_app_flutter/models/http_exception.dart';
import 'package:note_app_flutter/models/note.dart';

class Notes with ChangeNotifier {
  List<Note> _notes = [];

  final String? authToken;
  final String? userId;

  String? orderByTitle;
  String? orderByCreatedDate;
  String? orderByUpdatedDate;

  Notes(this.authToken, this.userId, this._notes);

  List<Note> get notes {
    return [..._notes];
  }

  Future<void> fetchNotes() async {
    final queryParams = {
      'bytitle': orderByTitle,
      'bycreateddate': orderByCreatedDate,
      'byupdateddate': orderByUpdatedDate
    };

    final url =
        Uri.http('nodejs-note-app.herokuapp.com', '/notes', queryParams);

    var response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ' + authToken!,
      },
    );

    var extractedData = json.decode(response.body);
    if (extractedData == null) {
      return;
    }

    _notes = notesFromJson(extractedData["notes"]);
    notifyListeners();
  }

  Future<void> fetchNotesByCategoryId(String catId) async {
    final queryParams = {
      'bytitle': orderByTitle,
      'bycreateddate': orderByCreatedDate,
      'byupdateddate': orderByUpdatedDate
    };
    final url = Uri.http(
        'nodejs-note-app.herokuapp.com', '/notes/category/$catId', queryParams);

    var response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ' + authToken!,
      },
    );

    var extractedData = json.decode(response.body);
    if (extractedData == null) {
      return;
    }

    _notes = notesFromJson(extractedData["notes"]);
    print(_notes);
    notifyListeners();
  }

  Note fetchNoteById(String id) {
    return _notes.firstWhere((note) => note.id == id);
  }

  Future<void> addNote(Map<String, Object?> note) async {
    final url = Uri.http('nodejs-note-app.herokuapp.com', '/notes/');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer ' + authToken!,
        },
        body: json.encode({
          'title': note['title'],
          'sections': note['sections'],
          'category': note['category'],
        }),
      );

      if (response.statusCode >= 400) {
        notifyListeners();
        throw HttpException('Could not Add note.');
      }
      //final extractedData = json.decode(response.body);
      //print(extractedData['note']);

      fetchNotes();
      notifyListeners();
    } catch (error) {
      print(error);
      throw error; // throw error here to handle it in edit_product_screen.dart
    }
  }

  Future<void> updateNote(String noteId, Map<String, Object?> note) async {
    final noteIndex = _notes.indexWhere((n) => n.id == noteId);
    if (noteIndex >= 0) {
      final url = Uri.http('nodejs-note-app.herokuapp.com', '/notes/$noteId');

      final response = await http.put(
        url,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer ' + authToken!,
        },
        body: json.encode({
          'title': note['title'],
          'sections': note['sections'],
          'category': note['category'],
        }),
      );

      if (response.statusCode >= 400) {
        notifyListeners();
        throw HttpException('Could not update note.');
      }
      fetchNotes();
      //_notes[noteIndex] = note;
      notifyListeners();
    }
  }

  Future<void> deleteNote(String noteId) async {
    final url = Uri.http('nodejs-note-app.herokuapp.com', '/notes/$noteId');
    final existingNoteIndex = _notes.indexWhere((c) => c.id == noteId);
    Note? existingNote = _notes[existingNoteIndex];
    Future.delayed(const Duration(seconds: 0), () {
      _notes.removeAt(existingNoteIndex);
    });
    notifyListeners();
    final response = await http.delete(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ' + authToken!,
      },
    );

    fetchNotes();
    if (response.statusCode >= 400) {
      _notes.insert(existingNoteIndex, existingNote);
      notifyListeners();
      throw HttpException('Could not delete note.');
    }
    existingNote = null;
  }
}
