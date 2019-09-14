import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:task/repository/note_repository.dart';
import 'package:task/repository/task_repository.dart';
import 'package:task/scoped-model/configurations/theme.dart';
import 'package:task/scoped-model/notes.dart';
import '../models/date.dart';

import '../data_base/DBhelper.dart';
import './configurations/sort_options.dart';

import '../models/task.dart';
import '../models/label.dart';

class TasksModel extends Model with SortOptions, AppTheme, NotesModel {
  // tasks
  final LabelDB labelDataBase = LabelDB();

  final TaskRepo _taskRepo = TaskRepo();
  final NoteRepo _noteRepo = NoteRepo();

  Future<Null> setData() async {
    await setAppTheme();
    _tasks = await _taskRepo.fetchTasks();
    _labels = await _taskRepo.fetchLabels();
    notes = await _noteRepo.fetchNotes();
    await setSortOptions();
    return null;
  }

  List<Task> _tasks = [];
  List<Label> _labels = [];

  bool Function(Task) _taskMustBe = (Task task) => true;

  List<Task> get tasks {
    return List.from(_tasks);
  }

  List<Task> get tasksWhere {
    List<Task> tasks = _tasks.where(_taskMustBe).toList();
    if (bindCompleted) tasks = tasks.where((task) => !task.done).toList();
    if (sortPriority)
      tasks.sort((a, b) {
        // if (a.priority == 'High') return 1;
        if (a.priority == 'Medium' && b.priority == 'High') return 1;
        if (a.priority == 'Low' &&
            (b.priority == 'High' || b.priority == 'Medium')) return 1;
        if (a.priority == 'None' && b.priority != 'None') return 1;
        return -1;
      });
    return tasks;
  }

  List<Task> tasksOfDay(DateTime selectedDay) {
    if (selectedDay == null) return [];
    return _tasks
        .where((task) =>
            task.date != null &&
            ((task.date.repeat &&
                    ((task.date.every == Every.day) ||
                        (task.date.every == Every.month &&
                            task.date.date.day == selectedDay.day) ||
                        (task.date.every == Every.week &&
                            task.date.dayOfRepeat[selectedDay.weekday]))) ||
                (task.date.date.year == selectedDay.year &&
                    task.date.date.month == selectedDay.month &&
                    task.date.date.day == selectedDay.day)))
        .toList();
  }

  Task findTaskById(String id) {
    return _tasks.firstWhere((task) => task.id == id);
  }

  int findTaskIndexById(String id) {
    return _tasks.indexWhere((task) => task.id == id);
  }

  void addTask(Task task) async {
    // final uuid = Uuid();
    // final String id = uuid.v4();
    // final String dateId = uuid.v4();
    // if (task.date != null) task.date.id = dateId;
    // Task newTask = Task(
    //     title: task.title,
    //     priority: task.priority,
    //     labels: (task.labels == null) ? '' : task.labels,
    //     location: (task.location == null) ? '' : task.location,
    //     note: (task.note == null) ? '' : task.note,
    //     done: false,
    //     date: task.date,
    //     id: id);
    // _tasks.add(newTask);
    // taskDataBase.insertTask(newTask);
    final newTask = await _taskRepo.addTask(task);
    _tasks.add(newTask);
    notifyListeners();
  }

  void updateTask(Task task) {
    // if (selectedTaskIndex == null) return;
    // final String id = _tasks[selectedTaskIndex].id;
    // _tasks[selectedTaskIndex] = task;
    // _tasks[selectedTaskIndex].id = id;
    // taskDataBase.updateTask(_tasks[selectedTaskIndex]);
    // selectTaskId(null);
    // notifyListeners();
  }

  void deleteTask(String id) {
    int i = findTaskIndexById(id);
    if (i == null) return;
    Task task = _tasks[i];
    if (task.note != null && task.note != '') {
      removeNote(task.note);
    }
    _tasks.removeAt(i);
    _taskRepo.removeTask(task);
  }

  // Future<Null> setTasks() async {
  //   _tasks = await taskDataBase.getTasks();
  //   return null;
  // }

  void selectTaskFilter(bool Function(Task) func) {
    _taskMustBe = func;
    notifyListeners();
  }

  void toggleTaskState(String id) {
    int selectedTaskIndex = findTaskIndexById(id);
    if (selectedTaskIndex == null) return;
    _tasks[selectedTaskIndex].done = !_tasks[selectedTaskIndex].done;
    _taskRepo.updateTask(_tasks[selectedTaskIndex]);
    notifyListeners();
  }

  void deleteNoteFromTask(String id) {
    Task task = _tasks.firstWhere((t) => t.note == id);
    task.note = '';
    _taskRepo.updateTask(task);
    notifyListeners();
  }

/* Labels */

  List<Label> get labels => [..._labels];

  List<Label> get labelsChecked =>
      _labels.where((label) => label.checked).toList();

  Future<Null> setLabels() async {
    _labels = await labelDataBase.getLabels();
    _labels.insert(
      0,
      Label('work', color: Color(0xfffe0000)),
    );
    _labels.insert(
      0,
      Label('project', color: Color(0xffefca08)),
    );
    _labels.insert(
      0,
      Label('personal', color: Color(0xff00cc65)),
    );
    return null;
  }

  Label findByName(String label) {
    return _labels.firstWhere((l) => l.label == label);
  }

  void addLabel(Label label) {
    bool existe = false;

    for (int i = 0; i < _labels.length; i++) {
      if (_labels[i].label == label.label) existe = true;
    }

    if (!existe) {
      labelDataBase.insertLabel(label);
      _labels.add(label);
    }
  }

  void updateLabel(Label label) {
    int i = _labels.indexWhere((l) => label.label == l.label);
    _labels[i] = label;
    labelDataBase.updateLabel(label);
    notifyListeners();
  }

  void removeLabel(Label label) {
    int j = 0;

    j = _labels.indexWhere((l) => l.label == label.label);
    _tasks.forEach((task) {
      if (task.labels.contains(label.label)) {
        List ls = task.labels.split('/');
        ls.removeAt(ls.indexWhere((l) => l == label.label));
        task.labels = ls.join('/');
        _taskRepo.updateTask(task);
      }
    });

    labelDataBase.deleteLabel(label.label);
    _labels.removeAt(j);
  }

  void toogleChecked(int index, int last) {
    //bool allNotChecked = true;
    // if (index == -1) {
    //   Label.allTasks.checked = !Label.allTasks.checked;
    //   if (Label.allTasks.checked)
    //     for (int i = 0; i < _labels.length; i++) _labels[i].checked = false;
    //   else {
    //     for (int i = 0; i < _labels.length; i++)
    //       if (_labels[i].checked) allNotChecked = false;
    //     if (allNotChecked) Label.allTasks.checked = true;
    //   }
    // } else {
    //   _labels[index].checked = !_labels[index].checked;
    //   if (_labels[index].checked)
    //     Label.allTasks.checked = false;
    //   else {
    //     for (int i = 0; i < _labels.length; i++)
    //       if (_labels[i].checked) allNotChecked = false;
    //     if (allNotChecked) Label.allTasks.checked = true;
    //   }
    // }

    if (index == last) return;

    if (index == -1)
      Label.allTasks.checked = true;
    else
      _labels[index].checked = true;
    if (last == -1)
      Label.allTasks.checked = false;
    else
      _labels[last].checked = false;

    if (Label.allTasks.checked)
      selectTaskFilter((Task task) => true);
    else
      selectTaskFilter((Task task) {
        List<String> taskLabels = task.labels.split('/');
        for (int i = 0; i < taskLabels.length; i++) {
          for (int j = 0; j < labelsChecked.length; j++)
            if (taskLabels[i] == labelsChecked[j].label) return true;
        }
        return false;
      });
  }
}
