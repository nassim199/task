import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:task/models/date.dart';
import 'package:uuid/uuid.dart';

import '../data_base/DBhelper.dart';

import '../models/task.dart';
import '../models/label.dart';

class TaskRepo {
  final TaskDB taskDataBase = TaskDB();

  Future<List<Task>> fetchTasks() async {
    List<Task> tasks = await taskDataBase.getTasks();
    return tasks;
  }

  Future<List<Label>> fetchLabels() async {
    List<Label> labels = await taskDataBase.getLabels();
    return labels;
  }

  Future<Task> addTask(Task task) async {
    final uuid = Uuid();
    final String id = uuid.v4();
    if (task.date != null) {
      final String dateId = uuid.v4();
      task.date.id = dateId;
      if (task.date.reminder) {
        Date date = task.date;
        androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          'your channel description',
        );
        iOSPlatformChannelSpecifics = IOSNotificationDetails();
        platformChannelSpecifics = NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        TimeOfDay t;
        if (date.time == null) {
          t = TimeOfDay(hour: 9, minute: 0);
        } else {
          t = date.time;
        }
        if (date.repeat) {
          if (date.every == 'day') {
            flutterLocalNotificationsPlugin.showDailyAtTime(task.notId, 'tasks',
                task.title, Time(t.hour, t.minute), platformChannelSpecifics);
          } else if (date.every == 'week') {
            int i = task.notId, j;
            List<bool> dayOfRepeat = List.from(date.dayOfRepeat);
            while (dayOfRepeat.contains(true)) {
              j = dayOfRepeat.indexWhere((d) => d);
              dayOfRepeat[j] = false;
              flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
                  i,
                  'tasks',
                  task.title,
                  Day.values[j],
                  Time(t.hour, t.minute),
                  platformChannelSpecifics);
              i = i * 10 + i;
            }
            print(task.date.dayOfRepeat);
          } else {
            //TODO: implement monthly notifications
          }
        } else {
          DateTime d = DateTime(
              date.date.year, date.date.month, date.date.day, t.hour, t.minute);
          await flutterLocalNotificationsPlugin.schedule(
              task.notId, 'tasks', task.title, d, platformChannelSpecifics);
        }
      }
    }
    task.id = id;
    await taskDataBase.insertTask(task);
    return task;
  }

  Future<void> removeTask(Task task) async {
    if (task.date.reminder) {
      if (!task.date.repeat || task.date.every != 'week')
        flutterLocalNotificationsPlugin.cancel(task.notId);
      else if (task.date.repeat) {
        int i = task.notId, j;
        List<bool> dayOfRepeat = List.from(task.date.dayOfRepeat);
        while (dayOfRepeat.contains(true)) {
          j = dayOfRepeat.indexWhere((d) => d);
          dayOfRepeat[j] = false;
          flutterLocalNotificationsPlugin.cancel(i);
          i = i * 10 + i;
        }
      }
    }
    await taskDataBase.deleteTask(task);
  }

  Future<void> updateTask(Task task) {
    taskDataBase.updateTask(task);
    return null;
  }

  // notifications
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid;
  var initializationSettingsIOS,
      initializationSettings,
      androidPlatformChannelSpecifics,
      iOSPlatformChannelSpecifics;
  var platformChannelSpecifics;

  TaskRepo() {
    initializationSettingsIOS = IOSInitializationSettings();
    initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  //Labels

  Future<void> addLabel(Label label) async {
    await taskDataBase.insertLabel(label);
  }

  Future<void> updateLabel(Label label) async {
    await taskDataBase.updateLabel(label);
  }

  Future<void> deleteLabel(String label) async {
    await taskDataBase.deleteLabel(label);
  }
}
