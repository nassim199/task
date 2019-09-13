import 'package:flutter/material.dart';
import 'package:task/models/label.dart';
import 'package:task/scoped-model/tasks.dart';
import 'package:task/widgets/color_slider.dart';
import 'package:scoped_model/scoped_model.dart';

class LabelManage extends StatefulWidget {
  @override
  _LabelManageState createState() => _LabelManageState();
}

class _LabelManageState extends State<LabelManage> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TasksModel>(
      builder: (BuildContext context, Widget child, TasksModel model) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey[200],
            elevation: 0,
            title: Text(
              'manage labels',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: model.labels.length,
                  itemBuilder: (ctx, index) {
                    return Dismissible(
                      background: Container(
                        alignment: Alignment.centerLeft,
                        color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      key: Key(model.labels[index].label),
                      direction: DismissDirection.startToEnd,
                      onDismissed: (direction) {
                        model.removeLabel(model.labels[index]);
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                        color: (index.isEven) ? Colors.white : Colors.grey[200],
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Text(model.labels[index].label),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Label label = model.labels[index];
                                    showDialog(
                                      context: context,
                                      builder: (context) => ColorSlider(
                                          noteColor: Colors.white,
                                          callBackColorTapped: (color) {
                                            setState(() {
                                              label.color = color;
                                            });
                                            Navigator.of(context).pop();
                                          }),
                                    );
                                    model.updateLabel(label);
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: model.labels[index].color,
                                  ),
                                ),
                              ],
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              FloatingActionButton.extended(
                backgroundColor: Theme.of(context).primaryColor,
                label: Text('add a label'),
                icon: Icon(Icons.add),
                onPressed: () {
                  showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    context: context,
                    builder: (context) => AddLabel(model.addLabel),
                  );
                },
              ),
              SizedBox(
                height: 15,
              )
            ],
          ),
        );
      },
    );
  }
}

class AddLabel extends StatefulWidget {
  final Function addLabel;

  AddLabel(this.addLabel);

  @override
  _AddLabelState createState() => _AddLabelState();
}

class _AddLabelState extends State<AddLabel> {
  Label newLabel = Label('', color: Colors.black);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width - 110,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: TextField(
              onChanged: (str) {
                setState(() {
                  newLabel.label = str;
                });
              },
              decoration: InputDecoration(hintText: 'label name'),
            ),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => ColorSlider(
                    noteColor: Colors.white,
                    callBackColorTapped: (Color color) {
                      setState(() {
                        newLabel.color = color;
                      });

                      Navigator.of(context).pop();
                    }),
              );
            },
            child: CircleAvatar(
              backgroundColor: newLabel.color,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 8.0,
            ),
            child: FloatingActionButton(
              elevation: 1,
              key: Key('addLabel'),
              backgroundColor: (newLabel.label == '')
                  ? Colors.grey[400]
                  : Theme.of(context).primaryColor,
              mini: true,
              onPressed: () {
                if (newLabel.label != '') {
                  widget.addLabel(newLabel);
                  Navigator.of(context).pop();
                }
              },
              child: Icon(Icons.arrow_upward),
            ),
          ),
        ],
      ),
    );
  }
}
