import 'package:flutter/material.dart';
import '../model/note.dart';
import '../service/storage_service.dart';

class HomePage extends StatefulWidget {
  final StorageService storageService;

  const HomePage({super.key, required this.storageService});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> notes = [];
  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  void loadNotes() async {
    final data = await widget.storageService.getNotes();
    setState(() => notes = data);
  }

  // ================= CREATE =================
  void addNote() async {
    await widget.storageService.addNote(
      Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: titleController.text,
        description: descController.text,
      ),
    );
    titleController.clear();
    descController.clear();
    loadNotes();
    Navigator.pop(context);
  }

  // ================= UPDATE =================
  void showEditDialog(Note note) {
    titleController.text = note.title;
    descController.text = note.description;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Catatan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Judul'),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await widget.storageService.updateNote(
                Note(
                  id: note.id,
                  title: titleController.text,
                  description: descController.text,
                ),
              );
              titleController.clear();
              descController.clear();
              loadNotes();
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  // ================= DELETE =================
  void deleteNote(String id) async {
    await widget.storageService.deleteNote(id);
    loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CRUD Notes')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Tambah Catatan'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Judul'),
                ),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: 'Deskripsi'),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: addNote,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
      body: notes.isEmpty
          ? const Center(child: Text('Belum ada data'))
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(notes[i].title),
                subtitle: Text(notes[i].description),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => showEditDialog(notes[i]),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => deleteNote(notes[i].id),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}