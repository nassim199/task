import 'package:flutter/material.dart';

enum Every { day, week, month, year }

String everyToString(Every every) {
  if (every == Every.day)
    return 'day';
  else if (every == Every.week)
    return 'week';
  else if (every == Every.month)
    return 'month';
  else if (every == Every.year)
    return 'year';
  else
    return '';
}

Every everyFromString(String every) {
  if (every == 'dat')
    return Every.day;
  else if (every == 'week')
    return Every.week;
  else if (every == 'month')
    return Every.month;
  else if (every == 'year') return Every.year;

  return null;
}

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
  Every every;
  int occurence;
  int repeatDate;
  List<bool> dayOfRepeat;
  bool reminder;
  Duration before;
  TimeOfDay at;

  Date({
    this.id,
    this.date,
    this.time,
    this.repeat = false,
    this.every,
    this.occurence = 1,
    this.repeatDate,
    this.reminder = false,
    this.before,
    this.at,
  }) {
    if (this.before == null) this.before = Duration(minutes: 0);
    this.dayOfRepeat = [];
    if (this.before == null) this.before = Duration();
    for (int i = 0; i < 7; i++) {
      this.dayOfRepeat.add(false);
    }
  }

  Date.fromMap(Map<String, dynamic> dateMap) {
    List<String> util;
    util = dateMap['date'].split('/');
    DateTime d = DateTime(int.parse(util[0]), int.parse(util[1]), int.parse(util[2])); 
    util = dateMap['time'] == '' ? [] : dateMap['time'].split('/');
    TimeOfDay t =
        dateMap['time'] == '' ? null : TimeOfDay(hour: int.parse(util[0]), minute: int.parse(util[1]));
    util = dateMap['at'] == '' ? [] : dateMap['at'].split('/');
    TimeOfDay a =
        dateMap['at'] == '' ? null : TimeOfDay(hour: int.parse(util[0]), minute: int.parse(util[1])); 
    this.id = dateMap['id'];
    this.date = d;
    this.time = t;
    this.repeat = dateMap['repeat'] == 1 ? true : false;
    this.every = everyFromString(dateMap['every']);
    this.occurence = dateMap['occurence'];
    this.repeatDate = dateMap['repeatDay'];
    this.reminder = dateMap['reminder'] == 1 ? true : false;
    this.before = dateMap['before'] == null ? null : Duration(minutes: dateMap['before']);
    this.at = a;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'date': '${this.date.year}/${this.date.month}/${this.date.day}',
      'time': this.time == null ? '' : '${this.time.hour}/${this.time.minute}',
      'repeat': this.repeat ? 1 : 0,
      'every': everyToString(this.every),
      'occurence': this.occurence,
      'repeatDay': this.repeatDate,
      'reminder': this.reminder ? 1 : 0,
      'before': this.before.inMinutes,
      'at': this.at == null ? '' : '${this.at.hour}/${this.at.minute}',
    };
  }
}
