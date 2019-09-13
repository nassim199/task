import 'dart:core';
import 'package:uuid/uuid.dart';

import '../data_base/DBhelper.dart';

import '../models/task.dart';
import '../models/label.dart';

class TaskRepo {
  final TaskDB taskDataBase = TaskDB();
  final LabelDB labelDataBase = LabelDB();

  Future<List<Task>> fetchTasks() async {
    List<Task> tasks = await taskDataBase.getTasks();
    return tasks;
  }

  Future<List<Label>> fetchLabels() async {
    List<Label> labels = await labelDataBase.getLabels();
    return labels;
  }

  Future<Task> addTask(Task task) async {
    final uuid = Uuid();
    final String id = uuid.v4();
    final String dateId = uuid.v4();
    if (task.date != null) task.date.id = dateId;
    Task newTask = Task(
        title: task.title,
        priority: task.priority,
        labels: (task.labels == null) ? '' : task.labels,
        location: (task.location == null) ? '' : task.location,
        note: (task.note == null) ? '' : task.note,
        done: false,
        date: task.date,
        id: id);
    await taskDataBase.insertTask(newTask);
    return newTask;
  }

  Future<void> removeTask(Task task) {
    taskDataBase.deleteTask(task);
    return null;
  }

  Future<void> updateTask(Task task) {
    taskDataBase.updateTask(task);
    return null;
  }
}