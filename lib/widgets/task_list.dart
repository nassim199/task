import 'package:flutter/material.dart';
import 'package:task/scoped-model/tasks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/task.dart';
import './task_item.dart';
import '../pages/tasks/task_detail.dart';

class TaskList extends StatefulWidget {
  final bool bindCompeleted, sortPriority; 
  final Function toggleTaskState;
  TaskList(this.bindCompeleted, this.sortPriority, this.toggleTaskState);

  @override
  _TaskList createState() => _TaskList();
}

class _TaskList extends State<TaskList> {
  List<Task> tasks;

  initState() {
    super.initState();
  }

  Widget _taskBuilder(
      Task task, Function toogleTaskState) {
    return Column(
      children: <Widget>[
        Slidable(
          key: Key(task.id),
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: Container(
            child: InkWell(
              child: TaskItem(task, widget.toggleTaskState),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return TaskDetail(task.id);
                    },
                  ),
                );
              },
            ),
          ),
          actions: <Widget>[
            (task.done)
                ? IconSlideAction(
                    color: Colors.deepOrange,
                    icon: Icons.undo,
                    onTap: () {
                      toogleTaskState(task.id);
                    },
                  )
                : IconSlideAction(
                    caption: 'Done',
                    color: Colors.blue,
                    icon: Icons.done,
                    onTap: () {
                      toogleTaskState(task.id);
                    },
                  ),
          ],
        ),
        Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TasksModel>(
      builder: (BuildContext context, Widget child, TasksModel model) {
        tasks = model.tasksWhere;
        if (tasks.length >0 ){

        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return _taskBuilder(
                tasks[index], model.toggleTaskState);
          },
          itemCount: tasks.length,
        );}
        else 
          return Center(child: Text('No tasks'),);
      },
    );
  }
}
