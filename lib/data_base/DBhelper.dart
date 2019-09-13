import 'package:flutter/material.dart';
import 'package:task/models/date.dart';
import 'package:task/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'dart:async';

import '../models/task.dart';
import '../models/label.dart';

class TaskDB {
  static Database dbInstance;

  Future<Database> get database async {
    if (dbInstance == null) dbInstance = await initDB();
    return dbInstance;
  }

  Future<Database> initDB() async {
    final db = openDatabase(
      join(await getDatabasesPath(), 'tasksDB.db'),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE tasks(id TEXT PRIMARY KEY, title TEXT, priority TEXT, labels TEXT,  location TEXT, note TEXT, date TEXT, done INT);"
        );
        return db.execute("CREATE TABLE date(id TEXT PRIMARY KEY, date TEXT, time TEXT, repeat INT, every TEXT, occurence INT, repeatDay TEXT, reminder INT, before INT, at TEXT);");
      },
      version: 2,
    );
    return db;
  }

  Future<void> insertTask(Task task) async {
    final Database db = await database;

    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (task.date != null)
    await db.insert('date', task.date.toMap());
  }

  Future<List<Task>> getTasks() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('tasks');
    final List<Map<String, dynamic>> dates = await db.query('date');
    return List.generate(maps.length, (i) {
      Task task = Task(
        title: maps[i]['title'],
        priority: maps[i]['priority'],
        done: maps[i]['done'] == 1,
        labels: maps[i]['labels'],
        note: maps[i]['note'],
        location: maps[i]['location'],
        id: maps[i]['id'],
      );
      if (maps[i]['date'] != '') {
      Date date = Date.fromMap(dates.firstWhere((d) => d['id'] == maps[i]['date']));
      task.date = date;
      }
      return task;
    });
  }

  Future<void> updateTask(Task task) async {
    final db = await database;

    await db.update(
      'tasks',
      task.toMap(),
      where: "id = ?",
      whereArgs: [task.id],
    );
    if (task.date != null)
    await db.update('date', task.date.toMap(), where: "id = ?", whereArgs: [task.date.id]);
  }

  Future<void> deleteTask(Task task) async {
    final db = await database;
    await db.delete(
      'tasks',
      where: "id = ?",
      whereArgs: [task.id],
    );
    if (task.date != null)
    await db.delete('date', where: "id = ?", whereArgs: [task.date.id]);
  }
}

class LabelDB {
  static Database dbInstance;

  Future<Database> get database async {
    if (dbInstance == null) dbInstance = await initDB();
    return dbInstance;
  }

  Future<Database> initDB() async {
    final db = openDatabase(
      join(await getDatabasesPath(), 'labelsDataBase.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE labels(label TEXT PRIMARY KEY, color INTEGER);",
        );
      },
      version: 1,
    );
    return db;
  }

  Future<void> insertLabel(Label label) async {
    final Database db = await database;

    await db.insert(
      'labels',
      {
        'label': label.label,
        'color': label.color.value,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateLabel(Label label) async {
    final db = await database;

    await db.update(
      'labels',
      {
        'label': label.label,
        'color': label.color.value,
      },
      where: "id = ?",
      whereArgs: [label.label],
    );
  }

  Future<List<Label>> getLabels() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('labels');

    return List.generate(maps.length, (i) {
      return Label(maps[i]['label'], color: Color(maps[i]['color']));
    });
  }

  Future<void> deleteLabel(String label) async {
    final db = await database;

    await db.delete(
      'labels',
      where: "label = ?",
      whereArgs: [label],
    );
  }
}

class NoteDB {
  static Database dbInstance;

  Future<Database> get database async {
    if (dbInstance == null) dbInstance = await initDB();
    return dbInstance;
  }

  Future<Database> initDB() async {
    final db = openDatabase(
      join(await getDatabasesPath(), 'notesDataBase.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE notes(id TEXT PRIMARY KEY, title TEXT, content TEXT, color INTEGER, isArchived INTEGER, isForTask INTEGER);",
        );
      },
      version: 1,
    );
    return db;
  }

  Future<void> insertNote(Note note) async {
    final Database db = await database;

    await db.insert(
      'notes',
      {
        'id': note.id,
        'title': note.title,
        'content': note.note,
        'color': note.color.value,
        'isArchived': note.isArchived ? 1 : 0,
        'isForTask': note.isArchived ? 1 : 0
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Note>> getNotes() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('notes');

    return List.generate(maps.length, (i) {
      return Note(
        id: maps[i]['id'],
        title: maps[i]['title'],
        note: maps[i]['content'],
        color: Color(maps[i]['color']),
        isArchived: maps[i]['isArchived'] == 1,
        isForTask: maps[i]['isForTask'] == 1,
      );
    });
  }

  Future<void> updateNote(Note note) async {
    final db = await database;

    await db.update(
      'notes',
      {
        'id': note.id,
        'title': note.title,
        'content': note.note,
        'color': note.color.value,
        'isArchived': note.isArchived ? 1 : 0,
        'isForTask': note.isArchived ? 1 : 0
      },
      where: "id = ?",
      whereArgs: [note.id],
    );
  }

  Future<void> deleteNote(String id) async {
    final db = await database;

    await db.delete(
      'notes',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
