import 'package:flutter/material.dart';
import 'package:task/scoped-model/tasks.dart';
import 'package:task/widgets/drawer.dart';
import 'package:task/widgets/note_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:scoped_model/scoped_model.dart';

import 'note_detail.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  var notes;
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TasksModel>(
      builder: (BuildContext context, Widget child, TasksModel model) {
        notes = model.notes;
        return Scaffold(
          drawer: SideDrawer(),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            title: Text(
              'notes',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => NoteDetail(true),
                    ),
                  );
                },
              )
            ],
          ),
          body: (notes.length > 0)
              ? StaggeredGridView.countBuilder(
                  crossAxisCount: 4,
                  itemCount: notes.length,
                  itemBuilder: (BuildContext context, int index) => Dismissible(
                    key: Key(notes[index].id),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) {
                      model.selectNoteId(notes[index].id);
                      model.deleteNote();
                    },
                    child: NoteCard(notes[index], model.selectNoteId),
                  ),
                  staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                )
              : Center(
                  child: Text('no notes'),
                ),
        );
      },
    );
  }
}
