import 'package:flutter/material.dart';
import 'package:task/widgets/drawer.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../models/label.dart';
import '../../scoped-model/tasks.dart';
import '../../widgets/task_list.dart';
import 'add_task.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPage createState() => _TaskPage();
}

class _TaskPage extends State<TaskPage> {
  int selectedLabel = -1;


  Widget _labelTag(Label label, Function toogle, int index) {
    return GestureDetector(
      onTap: () {
        toogle(index, selectedLabel);
        selectedLabel = index;
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 0,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: (label.checked) ? label.color : Colors.white,
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
            color: (label.checked) ? Colors.white : label.color,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TasksModel>(
      child: SideDrawer(),
      builder: (BuildContext context, Widget child, TasksModel model) {
        return Scaffold(
          drawer: child,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            title: Text(
              'tasks',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            actions: <Widget>[
              PopupMenuButton(
                onSelected: (value) {
                  if (value == 0) {
                    //  setState(() {
                    model.toogleShow();
                    //  });
                    // prefs.setBool('bindCompleted', model.bindCompleted);
                  } else if (value == 1) {
                    // showDialog(
                    //   context: context,
                    //   builder: (context) => Dialog(
                    //     insetAnimationDuration: Duration(milliseconds: 300),
                    //     child: Column(children: <Widget>[
                    //         Text('priority'),
                    //         Text('')
                    //     ],),
                    //   )
                    // );
                    //setState(() {
                    model.toogleSort();
                    //});
                    // prefs.setBool('sortPriority', model.sortPriority);
                  }
                },
                icon: Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 0,
                    child: model.bindCompleted
                        ? Text('show compeleted tasks')
                        : Text('bind completed tasks'),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: model.sortPriority
                        ? Text('sort by date of creation')
                        : Text('sort by priority'),
                  ),
                ],
              ),
            ],
          ),
          body: Column(
            children: <Widget>[
              Container(
                height: 45,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      Label.allTasks.color = Theme.of(context).primaryColor;
                      return _labelTag(Label.allTasks, model.toogleChecked, -1);
                    }
                    return _labelTag(model.labels[index - 1],
                        model.toogleChecked, index - 1);
                  },
                  itemCount: model.labels.length + 1,
                ),
              ),
              Expanded(
                  child: TaskList(model.bindCompleted, model.sortPriority, model.toggleTaskState)),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            //key: Key('add-task'),
            child: Icon(Icons.add),
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => AddTask(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
