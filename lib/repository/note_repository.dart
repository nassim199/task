import 'dart:core';

import 'package:task/models/note.dart';

import '../data_base/DBhelper.dart';


class NoteRepo {
  final NoteDB noteDataBase = NoteDB();

  Future<List<Note>> fetchNotes() async {
    List<Note> notes = await noteDataBase.getNotes();
    return notes;
  } 
}