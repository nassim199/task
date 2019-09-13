import 'package:task/models/note.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:uuid/uuid.dart';

import '../data_base/DBhelper.dart';

mixin NotesModel on Model {

  final NoteDB noteDataBase = NoteDB();

  List<Note> _notes = [];
  String _selectedNoteId;

  Future<Null> setNotes() async {
    _notes = await noteDataBase.getNotes();
    return null;
  }

  List<Note> get notes => _notes.where((note) => !note.isForTask).toList();

  set notes(n) {
    _notes = n;
  }

  Note get selectedNote {
    if (_selectedNoteId == null) return null;
    return _notes.firstWhere((note) => note.id == _selectedNoteId);
  }

  int get selectednoteIndex {
    if (_selectedNoteId == null) return null;
    return _notes.indexWhere((Note note) => note.id == _selectedNoteId);
  }

  Note findNoteById(String id) {
    if (id == null) return null;
    return _notes.firstWhere((note) => note.id == id);
  }

  void selectNoteId(String id) {
    _selectedNoteId = id;
  }

  void addNote(Note note) {
    final uuid = Uuid();
    final String id = uuid.v4();
    note.id = id;
    _notes.add(note);
    noteDataBase.insertNote(note);
  }

  void deleteNote() {
    int i = selectednoteIndex;
    print(i);
    noteDataBase.deleteNote(_notes[i].id);
    _notes.removeAt(i);
    selectNoteId(null);
    notifyListeners();
  }

  void removeNote(String id) {
    int i = _notes.indexWhere((note) => note.id == id);
    if (i == null || i == -1) return;
    noteDataBase.deleteNote(_notes[i].id);
    _notes.removeAt(i);
  }

  void updateNote(Note note) {
    int i = selectednoteIndex;
    if (i == null) return;
    final String id = _notes[i].id;
    _notes[i] = note;
    _notes[i].id = id;
    noteDataBase.updateNote(_notes[i]);
    selectNoteId(null);
    notifyListeners();
  }
}
