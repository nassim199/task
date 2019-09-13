import 'package:flutter/material.dart';
import 'package:task/pages/settings/labels_manage.dart';
import 'package:task/pages/settings/settings.dart';

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 30.0,
          ),
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                child: CircleAvatar(
                  child: Text(
                    'N',
                    style: TextStyle(color: Colors.white, fontSize: 43),
                  ),
                  radius: 30,
                ),
              ),
              Text('Hammadou Nassim')
            ],
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.receipt),
            title: Text('Mail Box'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.sync),
            title: Text('Synchronise'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Settings(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.label),
            title: Text('Manage labels'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => LabelManage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
