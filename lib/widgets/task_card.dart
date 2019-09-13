import 'package:flutter/material.dart';
import 'package:task/models/label.dart';

import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final Label label;

  TaskCard(this.task, this.label);

  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                offset: Offset(0.4, 1.5),
                blurRadius: 2,
              )
            ],
            color: Colors.white,
          ),
          child: Row(
            children: <Widget>[
              task.date.time == null
                  ? Container()
                  : Container(
                      width: 75,
                      height: 55,
                      decoration: BoxDecoration(
                        color: label == null
                            ? Theme.of(context).primaryColor
                            : label.color,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.black.withOpacity(0.3),
                        //     offset: Offset(1.0, 1.5),
                        //     blurRadius: 2,
                        //   )
                        // ],
                      ),
                      child: Center(
                        child: Text(
                          '${task.date.time.hour} : ${task.date.time.minute < 10 ? 0 : ''}${task.date.time.minute}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
              Expanded(
                child: Container(
                  height: 55,
                  //margin: EdgeInsets.all(3),
                  child: Center(
                    child: Text(
                      task.title,
                      style: TextStyle(fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
