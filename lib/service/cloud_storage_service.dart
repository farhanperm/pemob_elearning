import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/note.dart';
import 'storage_service.dart';

class CloudStorageService implements StorageService {
  final CollectionReference notesCollection =
      FirebaseFirestore.instance.collection('notes');

  @override
  Future<List<Note>> getNotes() async {
    final snapshot = await notesCollection.get();
    return snapshot.docs.map((doc) {
      return Note(
        id: doc.id,
        title: doc['title'],
        description: doc['description'],
      );
    }).toList();
  }

  @override
  Future<void> addNote(Note note) async {
    await notesCollection.add({
      'title': note.title,
      'description': note.description,
    });
  }

  @override
  Future<void> updateNote(Note note) async {
    await notesCollection.doc(note.id).update({
      'title': note.title,
      'description': note.description,
    });
  }

  @override
  Future<void> deleteNote(String id) async {
    await notesCollection.doc(id).delete();
  }
}