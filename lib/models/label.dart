import 'package:flutter/material.dart';

class Label {

  String label;
  Color color;
  bool checked;

  Label(this.label, {this.color = Colors.black, this.checked = false});

  static final Label allTasks = Label('All tasks', checked: true); 

}