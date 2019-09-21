import 'package:flutter/material.dart';

class Note {
  String id;
  String title;
  String content;
  Color color;
  bool isArchived;
  bool isForTask;
  bool isCheckList = false;
  List<Map<String, dynamic>> checkList = [];
  Note(
      {this.title = '',
      this.content = '',
      this.color = Colors.white,
      this.isForTask = false,
      this.id,
      this.isArchived = false});

  Note.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.title = map['title'];
    this.content = map['content'];
    this.color = Color(map['color']);
    this.isArchived = map['isArchived'] == 1;
    this.isForTask = map['isForTask'] == 1;
    this.isCheckList = map['isCheckList'] == 1;

    if (this.isCheckList) {
      checkList = this
          .content
          .split('\n')
          .map((value) => {
                'state': value[value.length - 1] == 't',
                'content': value.substring(0, value.length - 1)
              })
          .toList();
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'title': this.title,
      'content': this.contentSave,
      'color': this.color.value,
      'isArchived': this.isArchived ? 1 : 0,
      'isForTask': this.isArchived ? 1 : 0,
      'isCheckList': this.isCheckList ? 1 : 0
    };
  }


  String get contentSave {
    if (isCheckList) {
      return checkList
          .map((value) => value['content'] + ( value['state'] ? 't' : 'f') )
          .join('\n');
    } else
      return content;
  }

  void setCheckList(bool value, bool removeChecked) {
    isCheckList = value;
    if (value) {
      _contentToList();
    } else {
      _listToContent(removeChecked);
    }
  }

  void _contentToList() {
    List list = content.split('\n');
    checkList = list
        .map((value) => {
              'state': false,
              'content': value,
            })
        .toList();
  }

  void _listToContent(bool removeChecked) {
    if (removeChecked)
      checkList = checkList.where((value) => !value['state']).toList();
    content = checkList.map((value) => value['content']).join('\n');
    print(content);
  }
}
