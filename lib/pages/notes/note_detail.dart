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
  bool _isNewNote = false, reorder = false;
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
      _contentController.text = note.content;
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
            if (note.title != '' || note.content != '') {
              model.addNote(note);
            }
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
              IconButton(
                icon: Icon((reorder) ? Icons.check : Icons.archive),
                onPressed: () {
                  if (reorder) {
                    setState(() {
                      reorder = false;
                    });
                  } else {
                    //TODO: add archive
                  }
                },
              ),
              PopupMenuButton(
                color: note.color,
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
                    if (!_isNewNote) {
                      if (note.isForTask) {
                        model.deleteNoteFromTask(note.id);
                      }
                      model.selectNoteId(note.id);
                      model.deleteNote();
                    }
                    Navigator.of(context).pop();
                  } else if (selectedValue == 2) {
                    setState(() {
                      note.setCheckList(!note.isCheckList, false);
                      if (!note.isCheckList) {
                        _contentController.text = note.content;
                      }
                      reorder = false;
                    });
                  } else if (selectedValue == 3) {
                    setState(() {
                      reorder = true;
                    });
                  }
                },
                icon: Icon(Icons.more_vert),
                itemBuilder: (_) => [
                  PopupMenuItem(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.brush),
                        SizedBox(
                          width: 8,
                        ),
                        Text('choose color'),
                      ],
                    ),
                    value: 0,
                  ),
                  PopupMenuItem(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.delete),
                        SizedBox(
                          width: 8,
                        ),
                        Text('delete'),
                      ],
                    ),
                    value: 1,
                  ),
                  PopupMenuItem(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.list),
                        SizedBox(
                          width: 8,
                        ),
                        Text('${note.isCheckList ? 'remove' : 'add'} check list'),
                      ],
                    ),
                    value: 2,
                  ),
                  if (note.isCheckList && !reorder)
                    PopupMenuItem(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.reorder),
                          SizedBox(
                            width: 8,
                          ),
                          Text('Reorder'),
                        ],
                      ),
                      value: 3,
                    )
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
            child: Column(
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
                if (!note.isCheckList)
                  Expanded(
                    child: ListView(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: EditableText(
                              onChanged: (str) {
                                note.content = str;
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
                        ),
                      ],
                    ),
                  ),
                if (note.isCheckList && !reorder)
                  _buildCheckList(note.checkList),
                if (note.isCheckList && reorder)
                  _buildCheckListReorder(note.checkList)
              ],
            ),
          ),
        ),
      );
    });
  }

  _buildCheckList(List checkList) {
    return Expanded(
      child: ListView(
        children: [
          ...List.generate(checkList.length, (i) {
            return Row(
              children: <Widget>[
                Checkbox(
                  onChanged: (value) {
                    setState(() {
                      checkList[i]['state'] = !checkList[i]['state'];
                    });
                  },
                  value: checkList[i]['state'],
                ),
                Expanded(
                  child: TextFormField(
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(border: InputBorder.none),
                    initialValue: checkList[i]['content'],
                    onChanged: (value) {
                 
                      checkList[i]['content'] = value;
                    },
                    onEditingComplete: () {
                      print('compelete');
                    },
                  ),
                ),
              ],
            );
          }),
          Align(
            alignment: Alignment.bottomLeft,
            child: FlatButton.icon(
              icon: Icon(
                Icons.add,
                color: Colors.grey,
              ),
              label: Text(
                'Add an element',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              onPressed: () {
                setState(() {
                  checkList.add({'state': false, 'content': ''});
                });
              },
            ),
          )
        ],
      ),
    );
  }

  _buildCheckListReorder(List checkList) {
    return Expanded(
      child: ReorderableListView(
        children: List.generate(checkList.length, (i) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
            key: Key('$i'),
            child: Row(
              children: <Widget>[
                Icon(Icons.reorder),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      checkList[i]['content'],
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      checkList.removeAt(i);
                    });
                  },
                )
              ],
            ),
          );
        }),
        onReorder: (a, b) {
          var inter = checkList.removeAt(a);
          checkList.insert(b - 1, inter);
          setState(() {});
        },
      ),
    );
  }
}
