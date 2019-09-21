import 'package:flutter/material.dart';


List<String> daysOfWeek = [
  'sunday',
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
  'friday',
  'saturday'
];

List<String> monthsOfYear = [
  'january',
  'fabruary',
  'march',
  'april',
  'may',
  'june',
  'july',
  'august',
  'september',
  'october',
  'november',
  'december'
];

class Date {
  String id;
  DateTime date;
  TimeOfDay time;
  bool repeat;
  String every;
  List<bool> dayOfRepeat;
  bool reminder;

  Date({
    this.id,
    this.date,
    this.time,
    this.repeat = false,
    this.every,
    this.reminder = false,
  }) {
    this.dayOfRepeat = [];
    for (int i = 0; i < 7; i++) {
      this.dayOfRepeat.add(false);
    }
  }

  Date.fromMap(Map<String, dynamic> dateMap) {
    List<String> util;
    util = dateMap['time'] == '' ? [] : dateMap['time'].split('/');
    TimeOfDay t =
        dateMap['time'] == '' ? null : TimeOfDay(hour: int.parse(util[0]), minute: int.parse(util[1]));
    this.id = dateMap['id'];
    this.date = DateTime.parse(dateMap['date']);
    this.time = t;
    this.repeat = dateMap['repeat'] == 1 ? true : false;
    this.every = dateMap['every'];
    this.reminder = dateMap['reminder'] == 1 ? true : false;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'date': this.date.toIso8601String(),
      'time': this.time == null ? '' : '${this.time.hour}/${this.time.minute}',
      'repeat': this.repeat ? 1 : 0,
      'every': this.every,
      'reminder': this.reminder ? 1 : 0,
    };
  }
}
