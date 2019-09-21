import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/models/label.dart';

mixin AppTheme on Model {
  final List<Map<String, Color>> themes = [
    {
      'Primary': Color(0xFF82A2FF),
      'Light': Color(0xFFb6d3ff),
      'Dark': Color(0xFF4c74cb),
    },
    {
      'Primary': Color(0xFF535D80),
      'Light': Color(0xFF818ab0),
      'Dark': Color(0xFF283453),
    },
    {
      'Primary': Color(0xFFff1744),
      'Light': Color(0xFFff616f),
      'Dark': Color(0xFFc4001d),
    },
    {
      'Primary': Color(0xFF00bfa5),
      'Light': Color(0xFF5df2d6),
      'Dark': Color(0xFF008e76),
    },
    {
      'Primary': Color(0xFFf9a825),
      'Light': Color(0xFFffd95a),
      'Dark': Color(0xFFc17900),
    },
  ];

  int _selectedIndex = 1;
  SharedPreferences prefs;

  Future<Null> setAppTheme() async {
    prefs = await SharedPreferences.getInstance();
    _selectedIndex = prefs.getInt('selectedIndex') ?? 1;
    Label.allTasks.color = selectedTheme['Primary'];
    notifyListeners();
    return null;
  }

  Map<String, Color> get selectedTheme => themes[_selectedIndex];

  void selectTheme(int index) {
    if (index == _selectedIndex) return;
    _selectedIndex = index;
    Label.allTasks.color = selectedTheme['Primary'];
    notifyListeners();
    prefs.setInt('selectedIndex', index);
  }
}
