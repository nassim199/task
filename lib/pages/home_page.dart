import 'package:flutter/material.dart';

import './calendar/calendar.dart';
import './tasks/tasks_page.dart';
import './notes/notes_page.dart';

class ToDoList extends StatefulWidget {
  @override
  _ToDoList createState() => _ToDoList();
}

class _ToDoList extends State<ToDoList> {
  int _currentIndex = 1;
  List<Widget> children = [];

  @override
  void initState() {
    super.initState();
    children.add(Calendar());
    children.add(TaskPage());
    children.add(NotesPage());
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: IndexedStack(
      //   index: _currentIndex,
      //   children: [
      //     Calendar(),
      //     TaskPage(),
      //     NotesPage(),
      //   ],
      // ),
      body: children[_currentIndex],
      //   bottomNavigationBar: FancyTabBar(onTabTapped),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: Container(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            title: Container(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            title: Container(),
          )
        ],
      ),
    );
  }
}
