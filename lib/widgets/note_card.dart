import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:task/models/note.dart';
import 'package:task/pages/notes/note_detail.dart';

class NoteCard extends StatefulWidget {
  final Note note;
  final Function selectNoteId;
  final bool isForTask;

  const NoteCard(this.note, this.selectNoteId, {this.isForTask = false});

  @override
  _NoteCardState createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  double _fontSize;

  @override
  void initState() {
    super.initState();
    _fontSize = _determineFontSizeForContent(
        ((widget.note.note != null) ? widget.note.note.length : 0) +
            ((widget.note.title != null) ? widget.note.title.length : 0));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) {
                widget.selectNoteId(widget.note.id);
                return NoteDetail(false, note: widget.note, isForTask: widget.isForTask,);
              },
            ),
          );
        },
        child: Container(
          color: widget.note.color,
          padding: EdgeInsets.all(5),
          child: Column(
            children: <Widget>[
              (widget.note.title != null && widget.note.title != '')
                  ? AutoSizeText(
                      widget.note.title,
                      textScaleFactor: 1.5,
                      style: TextStyle(
                          fontSize: _fontSize, fontWeight: FontWeight.bold),
                    )
                  : Container(),
              (widget.note.title != null && widget.note.title != '')
                  ? Divider()
                  : Container(),
              AutoSizeText(
                widget.note.note,
                maxLines: 4,
                style: TextStyle(fontSize: _fontSize),
                textScaleFactor: 1.5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

num apearance(String string, String char) {
  num result = 0;

  for (int i = 0; i < string.length; i++) {
    if (string[i] == char) {
      result++;
    }
  }

  return result;
}

double _determineFontSizeForContent(int charCount) {
  double fontSize = 20;
  if (charCount > 110) {
    fontSize = 12;
  } else if (charCount > 80) {
    fontSize = 14;
  } else if (charCount > 50) {
    fontSize = 16;
  } else if (charCount > 20) {
    fontSize = 18;
  }
  return fontSize;
}
