import 'package:flutter/material.dart';

import '../models/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final Function toggleTaskState;

  TaskItem(this.task, this.toggleTaskState);

  _buildPriorityBadge(String priority) {
    Color color;
    switch (priority) {
      case 'None':
        color = Colors.white;
        break;
      case 'High':
        color = Colors.redAccent;
        break;
      case 'Medium':
        color = Colors.orangeAccent;
        break;
      case 'Low':
        color = Colors.blueAccent;
        break;
      default:
        color = Colors.white;
    }
    return SizedBox(
      width: 5.0,
      height: 50.0,
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(1.5)),
            color: color),
      ),
    );
  }

  getPriorityColor(String priority) {
    if (priority == 'High')
      return Colors.redAccent;

    if (priority == 'Medium')
      return Colors.orangeAccent;
    if (priority == 'Low')
      return Colors.blueAccent;
    return Colors.black;
  }

  Widget build(BuildContext context) {
    return Container(
      //     margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
      padding: EdgeInsets.only(top: 10.0),
      // decoration: BoxDecoration(
      //   shape: BoxShape.rectangle,
      //   border: Border(bottom: BorderSide(color: Colors.grey[500])),
      // ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //Icon(task.done ? Icons.check : Icons.crop_square, /* color: getPriorityColor(task.priority), */),
          Checkbox(
            value: task.done,
            onChanged: (value){
              toggleTaskState(task.id);
            },
            activeColor: Theme.of(context).primaryColor,
          ),
          Expanded(
           // width: MediaQuery.of(context).size.width - 100,
            child: Hero(
              tag: task.id,
              child: Text(
                task.title,
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: task.done ? Colors.grey[600] : Colors.black,
                    decoration: task.done
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
            ),
          ),
          _buildPriorityBadge(task.priority),
        ],
      ),
    );
  }
}
