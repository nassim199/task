import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task/models/label.dart';
import 'package:task/models/task.dart';
import 'package:task/widgets/note_card.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-model/tasks.dart';
import '../../models/date.dart';

class TaskDetail extends StatefulWidget {
  final String id;

  TaskDetail(this.id);
  @override
  _TaskDetail createState() => _TaskDetail();
}

class _TaskDetail extends State<TaskDetail> with TickerProviderStateMixin {
  ScrollController _scrollController;
  AnimationController _animationController, _controller;
  _scrollListener() {
    if (_scrollController.offset > 40) {
      _animationController.forward();
      _controller.reverse();
    } else {
      _animationController.reverse();
      _controller.forward();
    }
  }

  initState() {
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 300,
        ));
    _controller = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 300,
        ));
    _controller.forward();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  dispose() {
    super.dispose();
    _animationController.dispose();
    _controller.dispose();
  }

  Widget build(BuildContext context) {
    return ScopedModelDescendant<TasksModel>(
        builder: (BuildContext context, Widget child, TasksModel model) {
      Task task = model.findTaskById(widget.id);

      List<String> labelsListNames = task.labels.split('/');
      labelsListNames.removeLast();
      List<Label> labelsList =
          labelsListNames.map((l) => model.findByName(l)).toList();
      return Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 160,
              pinned: true,
              backgroundColor: _getColor(labelsList),
              iconTheme: IconThemeData(color: Colors.white),
              title: FadeTransition(
                opacity: CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(0, 1),
                ),
                child: Text(
                  task.title,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              actions: <Widget>[
                FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _controller,
                    curve: Interval(0, 1, curve: Curves.easeOut),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.delete_outline),
                    onPressed: () {
                      Navigator.of(context).pop();
                      model.deleteTask(task.id);
                    },
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: ScaleTransition(
                  scale: CurvedAnimation(
                    parent: _controller,
                    curve: Interval(0, 1),
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 63),
                    child: Text(
                      task.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  task.date == null ? Container() :
                  Column(children: <Widget>[
                    Text('date : ${task.date.date.year}/${task.date.date.month}/${task.date.date.day}'),
                    (task.date.time == null) ? Container() : Text('hour : ${task.date.time.hour}:${task.date.time.minute}'),
                    (task.date.repeat) ? Text('Repeat every : ${task.date.occurence} ${everyToString(task.date.every)}') : Container(),
                  ],),
                  task.priority != 'None'
                      ? Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(15),
                              child: Text('Priority :'),
                            ),
                            _getPriorityBadge(task.priority),
                          ],
                        )
                      : Container(),
                  task.labels != ''
                      ? Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(15),
                              child: Text('Labels :'),
                            ),
                            Expanded(
                              child: Container(
                                height: 45,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return _labelTag(labelsList[index]);
                                  },
                                  itemCount: labelsList.length,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  (task.note == '')
                      ? Container()
                      : Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(15),
                              child: Text('notes :'),
                            ),
                            Divider(),
                            NoteCard(model.findNoteById(task.note),
                                model.selectNoteId),
                          ],
                        ),
                  Container(
                    height: 300,
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  _getColor(List<Label> labels) {
    if (labels != null && labels.length != 0) {
      return labels[0].color;
    } else {
      return Theme.of(context).primaryColor;
    }
  }

  _getPriorityBadge(String priority) {
    Color color;
    if (priority == 'High')
      color = Colors.redAccent;
    else if (priority == 'Medium')
      color = Colors.orangeAccent;
    else
      color = Colors.blueAccent;

    return Container(
      padding: EdgeInsets.all(3),
      child: Text(
        priority,
        style: TextStyle(color: Colors.white),
      ),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.rectangle,
        border: Border.all(
          width: 1.5,
          color: color,
        ),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    );
  }

  Widget _labelTag(Label label) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 0,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: label.color,
        shape: BoxShape.rectangle,
        border: Border.all(
          width: 1.5,
          color: label.color,
        ),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Text(
        label.label,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
