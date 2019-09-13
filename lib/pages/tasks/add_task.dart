import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-model/tasks.dart';
import '../../models/task.dart';
import '../../widgets/description_options.dart';

class AddTask extends StatefulWidget {
  AddTask();
  _AddTask createState() => _AddTask();
}

class _AddTask extends State<AddTask> {
  String title;
  Task newTask = Task(title: '');
  Map<String, dynamic> taskMap;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    taskMap = {
      'id' : newTask.id,
      'title' : newTask.title,
      'priority' : newTask.priority,
      'done' : newTask.done,
      'labels' : newTask.labels,
      'note' : newTask.note,
      'location' : newTask.location,
      'date' : newTask.date,
    };
  }
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TasksModel>(
        builder: (BuildContext context, Widget child, TasksModel model) {
      return WillPopScope(
        onWillPop: () {
          if (newTask.note != '') {
            model.selectNoteId(newTask.note);
            model.deleteNote();
          }
          return Future.value(true);
        },
        child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                'add a task',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            body: ListView(
              padding: EdgeInsets.all(15.0),
              children: <Widget>[
                TaskForm(_formKey, (String value) => taskMap['title'] = value),
                SizedBox(
                  height: 20.0,
                ),
                DescriptionOptions((String option, value) {
                  setState(() {
                    taskMap[option] = value;
                  });
                }, Task.fromMap(taskMap), labels: model.labels),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: FloatingActionButton.extended(
                    heroTag: 'save',
                    backgroundColor: Theme.of(context).primaryColor,
                    icon: Icon(Icons.add),
                    label: Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (!_formKey.currentState.validate()) return;
                      _formKey.currentState.save();
                      Task newTask = Task.fromMap(taskMap);
                      model.addTask(newTask);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            )),
      );
    });
  }
}

class TaskForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Function saveTitle;

  TaskForm(this.formKey, this.saveTitle);
  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: TextFormField(
        autofocus: true,
        style: TextStyle(
          fontSize: 23.0,
          color: Colors.black,
        ),
        decoration: InputDecoration(
            hintText: 'Title',
            hintStyle: TextStyle(fontSize: 23.0),
            border: InputBorder.none),
        initialValue: '',
        onSaved: (String value) {
          widget.saveTitle(value);
        },
        validator: (String value) {
          if (value.isEmpty) return 'Title is required';
          return null;
        },
      ),
    );
  }
}
