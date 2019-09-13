import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './pages/home_page.dart';

import './scoped-model/tasks.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  final model = TasksModel();
  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  bool dataLoading = true;
  @override
  void initState() {
    widget.model.setData().then((_) {
      setState(() {
       dataLoading = false; 
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<TasksModel>(
      model: widget.model,
      child: ScopedModelDescendant<TasksModel>(
          builder: (BuildContext context, Widget child, TasksModel model) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ToDo-List',
          theme: ThemeData(
            primaryColor: model.selectdTheme,
          ),
          home: dataLoading ? Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ) : ToDoList(),
        );
      }),
    );
  }
}
