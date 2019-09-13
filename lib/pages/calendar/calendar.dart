import 'package:flutter/material.dart';
import 'package:task/models/task.dart';
import 'package:task/pages/tasks/task_detail.dart';
import 'package:task/scoped-model/tasks.dart';
import 'package:task/widgets/drawer.dart';
import 'package:task/widgets/task_card.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:task/models/date.dart';

class Calendar extends StatefulWidget {
  @override
  _Calendar createState() => _Calendar();
}

class _Calendar extends State<Calendar> with TickerProviderStateMixin {
  // Map<DateTime, List> _events;
  //TODO: add animation in showCalendar
  AnimationController _animationController;
  CalendarController _calendarController;
  DateTime _selectedMonth = DateTime.now(), _selectedDay = DateTime.now();
  List<Task> tasks;
  bool showCalendar = true;

  @override
  void initState() {
    super.initState();

    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    setState(() {
      _selectedDay = day;
      _selectedMonth = day;
    });
  }

  void _onVisibleDaysChanged(
      DateTime firstDay, DateTime lastDay, CalendarFormat _format) {
    setState(() {
      if (firstDay.month == lastDay.month)
        setState(() {
          _selectedMonth = firstDay;
        });
      else {
        if (_format == CalendarFormat.week) {
          if (_selectedMonth.month <= firstDay.month) {
            setState(() {
              _selectedMonth = firstDay;
            });
          } else {
            setState(() {
              _selectedMonth = lastDay;
            });
          }
        } else if (_format == CalendarFormat.twoWeeks) {
          setState(() {
            _selectedMonth = firstDay.add(Duration(days: 7));
          });
        } else {
          setState(() {
            _selectedMonth = firstDay.add(Duration(days: 10));
          });
        }
      }
      // if (_selectedDay != day && _format == CalendarFormat.week)
      // _selectedDay = day;
      // else
      //   _selectedDay = day1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TasksModel>(
      child: SideDrawer(),
      builder: (BuildContext context, Widget child, TasksModel model) {
        tasks = model.tasksOfDay(_selectedDay);
        tasks.sort((a, b) => a.date.time == null ? 1 : -1);
        return Scaffold(
          drawer: child,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            title: Text(
              '${monthsOfYear[_selectedMonth.month - 1]}, ${_selectedMonth.year}',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            // actions: <Widget>[
            //   IconButton(
            //     icon: showCalendar && _calendarController.calendarFormat == CalendarFormat.month ? Icon(Icons.keyboard_arrow_up) : Icon(Icons.keyboard_arrow_down),
            //     onPressed: () {
            //       if (!showCalendar || _calendarController.calendarFormat == CalendarFormat.month)
            //       setState(() {
            //         showCalendar = !showCalendar;
            //       });
            //       else {
            //         _calendarController.setCalendarFormat(CalendarFormat.month);
            //       }
            //     },
            //   )
            // ],
          ),
          body: Column(
            children: <Widget>[
              Container(
                child: _buildCalendar(),
                height: showCalendar ? null : 0,
              ),
              Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  TaskDetail(tasks[index].id)));
                        },
                        child: TaskCard(
                            tasks[index],
                            (tasks[index].labels == '')
                                ? null
                                : model.findByName(
                                    tasks[index].labels.split('/')[0])));
                  },
                ),
              ),
              // ...tasks.map((Task task) {
              //   return GestureDetector(
              //       onTap: () {
              //         Navigator.of(context).push(MaterialPageRoute(
              //             builder: (context) => TaskDetail(task.id)));
              //       },
              //       child: TaskCard(
              //           task,
              //           (task.labels == '')
              //               ? null
              //               : model.findByName(task.labels.split('/')[0])));
              // }).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      initialCalendarFormat: CalendarFormat.week,
      headerVisible: false,
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      formatAnimation: FormatAnimation.slide,
    );
  }
}
