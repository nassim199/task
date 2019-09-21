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
  Widget _labelTag(Label label, Function toogle, int index) {
    return GestureDetector(
      onTap: () {
        toogle(index);
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
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            title: Text(
              'tasks',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            actions: <Widget>[
              PopupMenuButton(
                onSelected: (value) {
                  if (value == 0) {
                    model.toogleShow();
                  } else if (value == 1) {
                    model.toogleSort();
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
                color: Colors.white,
                child: Container(
                  child: TextField(
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search tasks ...',
                        border: InputBorder.none),
                    onChanged: model.searchFilter,
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                  ),
                ),
              ),
              Container(
                height: 65,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(20)),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: ListView(scrollDirection: Axis.horizontal, children: [
                  _labelTag(Label.allTasks, model.toggleChecked, -1),
                  ...List.generate(model.labels.length,
                      (i) => _labelTag(model.labels[i], model.toggleChecked, i))
                ]),
              ),
              Expanded(
                  child: TaskList(model.bindCompleted, model.sortPriority,
                      model.toggleTaskState)),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            //key: Key('add-task'),
            child: Icon(Icons.add),
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
            onPressed: () async {
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
