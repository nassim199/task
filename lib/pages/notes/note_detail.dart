import 'package:flutter/material.dart';
import 'package:task/models/note.dart';
import 'package:task/scoped-model/tasks.dart';
import 'package:task/widgets/color_slider.dart';
import 'package:scoped_model/scoped_model.dart';

class NoteDetail extends StatefulWidget {
  final bool isNew;
  final Note note;
  final bool isForTask;
  NoteDetail(this.isNew, {this.note, this.isForTask = false});
  @override
  _NoteDetailState createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isNewNote = false;
  Note note;
  final _titleFocus = FocusNode();
  final _contentFocus = FocusNode();

  void bottomSheet(BuildContext context, Note note) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return ColorSlider(
            noteColor: note.color,
            callBackColorTapped: (Color color) {
              setState(() {
                note.color = color;
              });
            },
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _isNewNote = widget.isNew;
    if (_isNewNote) {
      note = Note();
    } else {
      note = widget.note;
      _titleController.text = note.title;
      _contentController.text = note.note;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TasksModel>(
        builder: (BuildContext context, Widget child, TasksModel model) {
      return WillPopScope(
        onWillPop: () {
          if (_isNewNote) {
            if (widget.isForTask) {
              note.isForTask = true;
            }
            if (note.title != '' || note.note != '')
              model.addNote(note);
            _isNewNote = false;
          } else
            model.updateNote(note);
          if (widget.isForTask) {
            Navigator.of(context).pop(note);
            return Future.value(false);
          } else
            return Future.value(true);
        },
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: note.color,
            actions: <Widget>[
              PopupMenuButton(
                onSelected: (int selectedValue) {
                  if (selectedValue == 0) {
                    showDialog(
                        context: context,
                        builder: (context) => ColorSlider(
                              noteColor: note.color,
                              callBackColorTapped: (Color color) {
                                setState(() {
                                  note.color = color;
                                });
                                Navigator.of(context).pop();
                              },
                            ));
                  } else if (selectedValue == 1) {
                    if (! _isNewNote ) {
                    model.selectNoteId(note.id);
                    model.deleteNote();
                    }
                    Navigator.of(context).pop();
                  }
                },
                icon: Icon(Icons.more_vert),
                itemBuilder: (_) => [
                  PopupMenuItem(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.brush),
                        Text('choose color'),
                      ],
                    ),
                    value: 0,
                  ),
                  PopupMenuItem(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.delete),
                        Text('delete'),
                      ],
                    ),
                    value: 1,
                  ),
                ],
              ),
              // IconButton(
              //   icon: Icon(Icons.more_vert),
              //   onPressed: () {
              //      bottomSheet(context, note);
              //   },
              // )
            ],
          ),
          body: Container(
            color: note.color,
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                  child: TextField(
                    onChanged: (str) {
                      note.title = str;
                    },
                    maxLines: 1,
                    decoration: InputDecoration(
                        hintText: 'Title',
                        hintStyle: TextStyle(fontSize: 23.0),
                        border: InputBorder.none),
                    controller: _titleController,
                    focusNode: _titleFocus,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                    cursorColor: Colors.blue,
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  child: EditableText(
                      onChanged: (str) {
                        note.note = str;
                      },
                      maxLines: 300,
                      controller: _contentController,
                      focusNode: _contentFocus,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                      cursorColor: Colors.blue,
                      backgroundCursorColor: Colors.blue),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
