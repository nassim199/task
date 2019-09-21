import 'dart:core';
import 'package:scoped_model/scoped_model.dart';
import 'package:task/repository/note_repository.dart';
import 'package:task/repository/task_repository.dart';
import 'package:task/scoped-model/configurations/theme.dart';
import 'package:task/scoped-model/notes.dart';

import './configurations/sort_options.dart';

import '../models/task.dart';
import '../models/label.dart';

class TasksModel extends Model with SortOptions, AppTheme, NotesModel {
  // tasks

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
  DateTime selectedDay = DateTime.now();

  bool Function(Task) _taskMustBe = (Task task) => true;
  String _searchFilter = "";

  List<Task> get tasks {
    return List.from(_tasks);
  }

  List<Task> get tasksWhere {
    List<Task> tasks = _tasks.where(_taskMustBe).toList();
    if (_searchFilter != "") tasks = tasks.where((task) => task.title.contains(_searchFilter)).toList();
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

  List<Task> get  tasksOfDay{
    if (selectedDay == null) return [];
    return _tasks
        .where((task) =>
            task.date != null &&
            ((task.date.repeat &&
                    ((task.date.every == 'day') ||
                        (task.date.every == 'month' &&
                            task.date.date.day == selectedDay.day) ||
                        (task.date.every == 'week' &&
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
    int i = -1;
    for (Task t in _tasks) {
      if (t.notId > i) i = t.notId;
    }
    i++;
    task.notId = i;
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

  void selectTaskFilter(bool Function(Task) func) {
    _taskMustBe = func;
    notifyListeners();
  }

  searchFilter(String value) {
    _searchFilter = value;
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

  List<Label> get labels => List.from(_labels);
  int _checkedLabel = -1;

  List<Label> get labelsChecked =>
      _labels.where((label) => label.checked).toList();



  Label findByName(String label) {
    return _labels.firstWhere((l) => l.label == label);
  }

  bool addLabel(Label label) {
    if (!_labels.contains(label)) {
      _labels.add(label);
      notifyListeners();
      _taskRepo.addLabel(label);
      return true;
    } else {
      return false;
    }
  }

  void updateLabel(Label label) {
    int i = _labels.indexWhere((l) => label.label == l.label);
    _labels[i] = label;
    _taskRepo.updateLabel(label);
    notifyListeners();
  }

  void removeLabel(Label label) {
    int j = 0;
    //get the index of the label
    j = _labels.indexWhere((l) => l.label == label.label);

    //remove the label from tasks that contains it
    _tasks.forEach((task) {
        List ls = task.labels.split('/');
      if (ls.contains(label.label)) {
        ls.removeAt(ls.indexWhere((l) => l == label.label));
        task.labels = ls.join('/');
        _taskRepo.updateTask(task);
      }
    });

    _labels.removeAt(j);
    _taskRepo.deleteLabel(label.label);
  }

  void toggleChecked(int index) {

    if (index == _checkedLabel) return;

    if (index == -1)
      Label.allTasks.checked = true;
    else
      _labels[index].checked = true;
    if (_checkedLabel == -1)
      Label.allTasks.checked = false;
    else
      _labels[_checkedLabel].checked = false;

    _checkedLabel = index;

    if (Label.allTasks.checked)
      selectTaskFilter((Task task) => true);
    else
      selectTaskFilter((Task task) {
        List<String> taskLabels = task.labels.split('/');
        return (taskLabels.contains(_labels[index].label));
      });
  }
}
