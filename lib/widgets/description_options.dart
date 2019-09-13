import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task/models/date.dart';
import 'package:task/models/note.dart';
import 'package:task/pages/notes/note_detail.dart';

import '../models/task.dart';
import '../models/label.dart';
import 'description helpers/datePicker.dart';
import 'description helpers/labelPicker.dart';

class DescriptionOptions extends StatefulWidget {
  final Function setOption;
  final List<Label> labels;
  final Task newTask;

  DescriptionOptions(this.setOption, this.newTask, {this.labels});

  @override
  _DescriptionOptions createState() => _DescriptionOptions();
}

class _DescriptionOptions extends State<DescriptionOptions> {
  Note taskNote;
  Date taskDate;

  void initState() {
    super.initState();
  }

  void setLabels(String newLabels) {
    widget.setOption('labels', newLabels);
    setState(() {
      widget.newTask.labels = newLabels;
    });
  }

  _getIcon(IconData primaryIcon, IconData secondaryIcon, String toCheck,
      {bool i = false}) {
    IconData icon;
    icon = (toCheck == '') ? primaryIcon : secondaryIcon;
    return Icon(icon, color: _getColor(toCheck, i));
  }

  _getColor(String toCheck, bool i) {
    if (i) {
      Color color;
      if (toCheck == 'High')
        color = Colors.redAccent;
      else if (toCheck == 'Medium')
        color = Colors.orangeAccent;
      else if (toCheck == 'Low')
        color = Colors.blueAccent;
      else
        color = Colors.black;
      return color;
    } else {
      return (toCheck == '') ? Colors.black : Theme.of(context).primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: FloatingActionButton(
            elevation: 3,
            mini: true,
            backgroundColor: Colors.white,
            heroTag: 'calendar',
            child: _getIcon(Icons.insert_invitation, Icons.calendar_today,
                widget.newTask.date == null ? '' : widget.newTask.date.id),
            onPressed: () {
              _showDatePicker(taskDate);
            },
          ),
        ),
        Expanded(
          child: FloatingActionButton(
            elevation: 3,
            mini: true,
            backgroundColor: Colors.white,
            heroTag: 'location',
            child: _getIcon(
                Icons.add_location, Icons.location_on, widget.newTask.location),
            onPressed: () {},
          ),
        ),
        Expanded(
          child: FloatingActionButton(
            elevation: 3,
            mini: true,
            backgroundColor: Colors.white,
            heroTag: 'label',
            child: _getIcon(
                Icons.label_outline, Icons.label, widget.newTask.labels),
            onPressed: () {
              showBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return LabelBottomSheet(
                        widget.labels, setLabels, widget.newTask.labels);
                  });
            },
          ),
        ),
        Expanded(
          child: FloatingActionButton(
            elevation: 3,
            mini: true,
            backgroundColor: Colors.white,
            heroTag: 'flag',
            child: _getIcon(
                Icons.outlined_flag, Icons.flag, widget.newTask.priority,
                i: true),
            onPressed: () {
              _showPriorityPicker();
            },
          ),
        ),
        Expanded(
          child: FloatingActionButton(
            elevation: 3,
            mini: true,
            backgroundColor: Colors.white,
            heroTag: 'note',
            child: _getIcon(Icons.note_add, Icons.note, widget.newTask.note),
            onPressed: () {
              if (taskNote == null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return NoteDetail(
                        true,
                        isForTask: true,
                      );
                    },
                  ),
                ).then((note) {
                  if (note == null) return;
                  print(note.isForTask);
                  setState(() {
                    taskNote = note;
                  });
                  widget.newTask.note = note.id;
                  widget.setOption('note', note.id);
                });
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return NoteDetail(
                        false,
                        note: taskNote,
                      );
                    },
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  void _showDatePicker(Date date) {
    showDialog(
        context: context,
        builder: (context) {
          return DatePicker(date, (date) {
            setState(() {
             taskDate = date; 
             widget.newTask.date = date;
             widget.setOption('date', date);
            });
          });
        });
  }

  void _showPriorityPicker() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('choose priority'),
            children: <Widget>[
              ListTile(
                title: Text('high'),
                leading: Icon(Icons.flag, color: Colors.redAccent),
                onTap: () {
                  setState(() {
                    widget.newTask.priority = 'High';
                  });
                  widget.setOption('priority', 'High');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('medium'),
                leading: Icon(Icons.flag, color: Colors.orangeAccent),
                onTap: () {
                  setState(() {
                    widget.newTask.priority = 'Medium';
                  });
                  widget.setOption('priority', 'Medium');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('low'),
                leading: Icon(Icons.flag, color: Colors.blueAccent),
                onTap: () {
                  setState(() {
                    widget.newTask.priority = 'Low';
                  });
                  widget.setOption('priority', 'Low');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('none'),
                leading: Icon(Icons.flag, color: Colors.white),
                onTap: () {
                  setState(() {
                    widget.newTask.priority = 'None';
                  });
                  widget.setOption('priority', 'None');
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}


