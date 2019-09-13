import 'package:flutter/material.dart';

class Note {
  String id;
  String title;
  String note;
  Color color;
  bool isArchived = false;
  bool isForTask;
  Note({this.title = '', this.note ='', this.color = Colors.white, this.isForTask = false, this.id, this.isArchived = false});

}