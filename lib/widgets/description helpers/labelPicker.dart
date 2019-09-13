import 'package:flutter/material.dart';
import 'package:task/models/label.dart';

class LabelBottomSheet extends StatefulWidget {
  final List<Label> labels;
  final Function setLabels;
  final String initialLabels;
  LabelBottomSheet(this.labels, this.setLabels, this.initialLabels);
  @override
  _LabelBottomSheet createState() => _LabelBottomSheet();
}

class _LabelBottomSheet extends State<LabelBottomSheet> {
  List<bool> labelsSelected = [];

  void initState() {
    List<String> oldLabels = widget.initialLabels.split('/');
    bool existe = false;
    for (int i = 0; i < widget.labels.length; i++) {
      for (int j = 0; j < oldLabels.length; j++) {
        if (widget.labels[i].label == oldLabels[j]) existe = true;
      }
      if (existe)
        labelsSelected.add(true);
      else
        labelsSelected.add(false);
      existe = false;
    }
    super.initState();
  }

  Widget _labelTag(Label label, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          labelsSelected[index] = !labelsSelected[index];
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 0,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: (labelsSelected[index]) ? label.color : Colors.white,
          shape: BoxShape.rectangle,
          border: Border.all(
            width: 1.5,
            color: label.color,
          ),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(
          children: <Widget>[
            Text(
              label.label,
              style: TextStyle(
                color: (labelsSelected[index]) ? Colors.white : label.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      elevation: 10,
      builder: (BuildContext context) {
        return Container(
          height: 45,
          child: Row(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return _labelTag(widget.labels[index], index);
                  },
                  itemCount: widget.labels.length,
                ),
              ),
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  String label = '';
                  for (int i = 0; i < labelsSelected.length; i++) {
                    if (labelsSelected[i]) {
                      label += widget.labels[i].label + '/';
                    }
                  }
                  print(label);
                  widget.setLabels(label);
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      },
      onClosing: () {
        String label = '';
        for (int i = 0; i < labelsSelected.length; i++) {
          if (labelsSelected[i]) {
            label += widget.labels[i].label;
          }
        }
        widget.setLabels(label);
      },
    );
  }
}
