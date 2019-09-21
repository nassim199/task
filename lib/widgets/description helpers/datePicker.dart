import 'package:flutter/material.dart';
import 'package:task/helpers/custom_dialog.dart';
import 'package:task/scoped-model/tasks.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:task/models/date.dart';

class DatePicker extends StatefulWidget {
  final Date date;
  final Function setDate;

  DatePicker(this.date, this.setDate);
  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  CalendarController _calendarController;
  DateTime dateSelected;
  TimeOfDay timeSelected;
  Date newDate;

  void _onDaySelected(DateTime day, List events) {
    dateSelected = day;
  }

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();

    if (widget.date == null) {
      newDate = Date();
      newDate.every = 'week';
      dateSelected = DateTime.now();
    } else {
      newDate = widget.date;
      dateSelected = widget.date.date;
      timeSelected = widget.date.time;
    }
  }

  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TasksModel>(
      builder: (BuildContext context, Widget child, TasksModel model) {
        return CustomDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                TableCalendar(
                  initialSelectedDay: dateSelected,
                  calendarController: _calendarController,
                  availableGestures: AvailableGestures.horizontalSwipe,
                  headerStyle: HeaderStyle(
                    centerHeaderTitle: true,
                    formatButtonVisible: false,
                  ),
                  onDaySelected: _onDaySelected,
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(Icons.access_time),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.grey[200],
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: FlatButton(
                                  child: Text(timeSelected == null
                                      ? 'define the hour'
                                      : timeSelected.format(context)),
                                  onPressed: () {
                                    showTimePicker(
                                      initialTime:
                                          timeSelected ?? TimeOfDay.now(),
                                      context: context,
                                    ).then((response) {
                                      setState(() {
                                        if (response != null)
                                          timeSelected = response;
                                      });
                                    });
                                  },
                                ),
                              ),
                              (timeSelected == null)
                                  ? Container()
                                  : IconButton(
                                      icon: Icon(Icons.clear),
                                      onPressed: () {
                                        setState(() {
                                          timeSelected = null;
                                        });
                                      },
                                    )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(Icons.repeat),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.grey[200],
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: FlatButton(
                                  child: (!newDate.repeat)
                                      ? Text('no repeat')
                                      : Text(' every ${newDate.every}'),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Repeat(newDate, setState);
                                      },
                                    );
                                  },
                                ),
                              ),
                              (!newDate.repeat)
                                  ? Container()
                                  : IconButton(
                                      icon: Icon(Icons.clear),
                                      onPressed: () {
                                        setState(() {
                                          newDate.repeat = false;
                                        });
                                      },
                                    )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(Icons.notifications),
                      ),
                      Expanded(child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text('reminder : '),
                      )),
                      Switch.adaptive(
                        onChanged: (value) {
                          setState(() {
                            newDate.reminder = value;
                          });
                        },
                        value: newDate.reminder,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text(
                        'Confirm',
                        style: TextStyle(color: Colors.blue[400]),
                      ),
                      onPressed: () {
                        newDate.date = dateSelected;
                        newDate.time = timeSelected;
                        widget.setDate(newDate);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Repeat extends StatefulWidget {
  final Date newDate;
  final Function newState;

  Repeat(this.newDate, this.newState);

  @override
  _RepeatState createState() => _RepeatState();
}

class _RepeatState extends State<Repeat> {
  Date _newDate;

  @override
  void initState() {
    super.initState();
    _newDate = widget.newDate;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      height: 200,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('every :'),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: DropdownButton(
                    value: _newDate.every,
                    isExpanded: true,
                    items: [
                      DropdownMenuItem(
                        child: Text('day'),
                        value: 'day',
                      ),
                      DropdownMenuItem(
                        child: Text('week'),
                        value: 'week',
                      ),
                      DropdownMenuItem(
                        child: Text('month'),
                        value: 'month',
                      ),
                      DropdownMenuItem(
                        child: Text('year'),
                        value: 'year',
                      ),
                    ],
                    onChanged: (String repeat) {
                      setState(() {
                        _newDate.every = repeat;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          (_newDate.every == 'week')
              ? Row(
                  children: daysOfWeek
                      .map(
                        (day) => Expanded(
                          child: FloatingActionButton(
                            mini: true,
                            backgroundColor: _newDate.dayOfRepeat[
                                    daysOfWeek.indexWhere((d) => d == day)]
                                ? Theme.of(context).primaryColor
                                : Colors.white,
                            heroTag: Key(day),
                            child: Text(
                              (day[0] + day[1]).toUpperCase(),
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () {
                              setState(() {
                                _newDate.dayOfRepeat[daysOfWeek
                                        .indexWhere((d) => d == day)] =
                                    !_newDate.dayOfRepeat[
                                        daysOfWeek.indexWhere((d) => d == day)];
                              });
                            },
                          ),
                        ),
                      )
                      .toList())
              : Container(),
          Expanded(
            child: Container(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  'Confirm',
                  style: TextStyle(color: Colors.blue[400]),
                ),
                onPressed: () {
                  widget.newState(() {
                    _newDate.repeat = true;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
