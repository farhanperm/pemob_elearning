import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/note.dart';
import 'storage_service.dart';

class LocalStorageService implements StorageService {
  static const String key = 'notes';

  @override
  Future<List<Note>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);
    if (data == null) return [];

    final List decoded = json.decode(data);
    return decoded.map((e) => Note.fromJson(e)).toList();
  }

  @override
  Future<void> addNote(Note note) async {
    final prefs = await SharedPreferences.getInstance();
    final notes = await getNotes();
    notes.add(note);
    prefs.setString(
      key,
      json.encode(notes.map((e) => e.toJson()).toList()),
    );
  }

  @override
  Future<void> deleteNote(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final notes = await getNotes();
    notes.removeWhere((e) => e.id == id);
    prefs.setString(
      key,
      json.encode(notes.map((e) => e.toJson()).toList()),
    );
  }
  
  @override
  Future<void> updateNote(Note note) async {
    final prefs = await SharedPreferences.getInstance();
    final notes = await getNotes();

    final index = notes.indexWhere((e) => e.id == note.id);
    if (index != -1) {
      notes[index] = note;
    }

    prefs.setString(
      key,
      json.encode(notes.map((e) => e.toJson()).toList()),
    );
  }
}