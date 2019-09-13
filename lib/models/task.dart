import 'package:flutter/material.dart';
import 'package:task/models/date.dart';

class Task {
  String title;
  String priority;
  String labels;
  String location;
  String note;
  Date date;
  bool done;
  String id;

  Task(
      {@required this.title,
      this.priority = 'None',
      this.done = false,
      this.labels = '',
      this.note = '',
      this.location = '',
      this.date,
      this.id = ''}) {
      //  if (this.date == null) this.date = Date();
      }
  Task.fromMap(Map<String, dynamic> taskMap) {
    this.id = taskMap['id'];
    this.title = taskMap['title'];
    this.priority = taskMap['priority'];
    this.done = taskMap['done'];
    this.labels = taskMap['labels'];
    this.note = taskMap['note'];
    this.location = taskMap['location'];
    this.date = taskMap['date'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id' : this.id,
      'title' : this.title,
      'priority' : this.priority,
      'done' : this.done,
      'labels' : this.labels,
      'note' : this.note,
      'location' : this.location,
      'date' : this.date == null ? '' : this.date.id,
    };
  }

}
