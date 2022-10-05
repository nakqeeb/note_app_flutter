import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/constant/api_routes.dart';
import '../models/http_exception.dart';
import '../models/note/note.dart';
import '../notifiers/notes_notifier.dart';

class NotesService {
  static Future<void> fetchNotes(NotesNotifier notesNotifier) async {
    final queryParams = {
      'bytitle': notesNotifier.orderByTitle,
      'bycreateddate': notesNotifier.orderByCreatedDate,
      'byupdateddate': notesNotifier.orderByUpdatedDate
    };

    final url = Uri.http(ApiRoutes.base_url, '/notes', queryParams);

    var response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ' + notesNotifier.authToken!,
      },
    );

    var extractedData = json.decode(response.body);
    if (extractedData == null) {
      return;
    }
    print(extractedData);
    final List<Note> loadedNotes = [];
    extractedData['notes'].forEach((noteData) {
      loadedNotes.add(Note.fromJson(noteData));
    });
    notesNotifier.notes = loadedNotes;
  }

  static Future<void> fetchNotesByCategoryId(
      String catId, NotesNotifier notesNotifier) async {
    final queryParams = {
      'bytitle': notesNotifier.orderByTitle,
      'bycreateddate': notesNotifier.orderByCreatedDate,
      'byupdateddate': notesNotifier.orderByUpdatedDate
    };
    final url =
        Uri.http(ApiRoutes.base_url, '/notes/category/$catId', queryParams);

    var response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ' + notesNotifier.authToken!,
      },
    );

    var extractedData = json.decode(response.body);
    if (extractedData == null) {
      return;
    }
    print(extractedData);
    final List<Note> loadedNotes = [];
    extractedData['notes'].forEach((noteData) {
      loadedNotes.add(Note.fromJson(noteData));
    });
    notesNotifier.notes = loadedNotes;
  }

  static Note fetchNoteById(String id, NotesNotifier notesNotifier) {
    return notesNotifier.notes.firstWhere((note) => note.id == id);
  }

  static Future<void> addNote(
      Map<String, Object?> note, NotesNotifier notesNotifier) async {
    final url = Uri.http(ApiRoutes.base_url, '/notes/');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer ' + notesNotifier.authToken!,
        },
        body: json.encode({
          'title': note['title'],
          'sections': note['sections'],
          'category': note['category'],
        }),
      );

      if (response.statusCode >= 400) {
        throw HttpException('Could not Add note.');
      }
      final extractedData = json.decode(response.body);
      print(extractedData['note']);
      fetchNotes(notesNotifier);
    } catch (error) {
      print(error);
      throw error; // throw error here to handle it in edit_product_screen.dart
    }
  }

  static Future<void> updateNote(String noteId, Map<String, dynamic> note,
      NotesNotifier notesNotifier) async {
    final noteIndex = notesNotifier.notes.indexWhere((n) => n.id == noteId);
    try {
      if (noteIndex >= 0) {
        final url = Uri.http(ApiRoutes.base_url, '/notes/$noteId');

        final response = await http.put(
          url,
          headers: {
            'Content-type': 'application/json',
            'Authorization': 'Bearer ' + notesNotifier.authToken!,
          },
          body: json.encode({
            'title': note['title'],
            'sections': note['sections'],
            'category': note['category'],
          }),
        );

        if (response.statusCode >= 400) {
          throw HttpException('Could not update note.');
        }
        fetchNotes(notesNotifier);
      }
    } catch (err) {
      print(err);
    }
  }

  static Future<void> deleteNote(
      String noteId, NotesNotifier notesNotifier) async {
    final url = Uri.http(ApiRoutes.base_url, '/notes/$noteId');
    notesNotifier.deleteNoteFromList(noteId, true);
    final response = await http.delete(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ' + notesNotifier.authToken!,
      },
    );
    fetchNotes(notesNotifier);
    if (response.statusCode >= 400) {
      notesNotifier.deleteNoteFromList(noteId, false);
      throw HttpException('Could not delete note.');
    }
  }
}
