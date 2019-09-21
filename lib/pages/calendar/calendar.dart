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
  //AnimationController _animationController;
  CalendarController _calendarController;
  DateTime _selectedMonth = DateTime.now();
  List<Task> tasks;
  bool showCalendar = false;

  @override
  void initState() {
    super.initState();

    _calendarController = CalendarController();

    // _animationController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(milliseconds: 400),
    // );
    // _animationController.forward();
  }

  @override
  void dispose() {
    //  _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
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
        tasks = model.tasksOfDay;
        tasks.sort((a, b) => a.date.time == null ? 1 : -1);
        return Scaffold(
          drawer: child,
          appBar: AppBar(
            elevation: 0,
            //backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(
              _getTitle(model.selectedDay),
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              IconButton(
                icon: showCalendar
                    ? Icon(Icons.keyboard_arrow_up)
                    : Icon(Icons.keyboard_arrow_down),
                onPressed: () {
                  setState(() {
                    showCalendar = !showCalendar;
                  });
                },
              )
            ],
          ),
          body: Column(
            children: <Widget>[
              Container(
                height: showCalendar ? null : 0,
                child: _buildCalendar(context, model),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius:
                      const BorderRadius.only(bottomLeft: Radius.circular(30)),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
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
            ],
          ),
        );
      },
    );
  }

  Widget _buildCalendar(context, model) {
    return TableCalendar(
      calendarController: _calendarController,
      initialCalendarFormat: CalendarFormat.week,
      headerVisible: false,
      initialSelectedDay: model.selectedDay,
      onDaySelected: (DateTime day, List events) {
        model.selectedDay = day;
        setState(() {
          _selectedMonth = day;
        });
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      formatAnimation: FormatAnimation.slide,
      calendarStyle: CalendarStyle(
        selectedColor: Theme.of(context).primaryColorDark,
        todayColor: Theme.of(context).primaryColorLight,
        todayStyle: TextStyle(color: Colors.black.withOpacity(0.44)),
        weekdayStyle:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        weekendStyle: const TextStyle(color: Colors.white60),
        outsideDaysVisible: false,
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Colors.black.withOpacity(0.54)),
        weekendStyle: const TextStyle(color: Colors.black38),
      ),
    );
  }

  String _getTitle(DateTime selectedDay) {
    DateTime today = DateTime.now();
    if ((showCalendar && selectedDay.month == _selectedMonth.month) || !showCalendar) {
      if (selectedDay.day == today.day &&
          selectedDay.month == today.month &&
          selectedDay.year == today.year) return "Today";
      today = today.add(Duration(days: 1));
      if (selectedDay.day == today.day &&
          selectedDay.month == today.month &&
          selectedDay.year == today.year) return "Tomorrow";
      today = today.subtract(Duration(days: 2));
      if (selectedDay.day == today.day &&
          selectedDay.month == today.month &&
          selectedDay.year == today.year) return "Yesterday";
    }

    String result = "";
    if (!showCalendar) result = '${selectedDay.day} ';
    result +=
        ' ${monthsOfYear[_selectedMonth.month - 1]}, ${_selectedMonth.year}';
    return result;
  }
}
