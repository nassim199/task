import 'package:flutter/material.dart';
import 'package:task/scoped-model/tasks.dart';
import 'package:scoped_model/scoped_model.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(
          'Settings',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      body: ScopedModelDescendant<TasksModel>(
        builder: (BuildContext context, Widget child, TasksModel model) {
          return ListView(
            children: <Widget>[
              ListTile(
                  title: Text('Theme'),
                  trailing: Container(
                    width: MediaQuery.of(context).size.width - 110,
                    child: ListView.builder(
                      itemCount: model.themes.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              model.selectTheme(index);
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: CircleAvatar(
                              backgroundColor: model.themes[index]['Primary'],
                              child: (model.selectedTheme == model.themes[index])
                                  ? Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    )
                                  : Container(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  onTap: () {}),
            ],
          );
        },
      ),
    );
  }
}
