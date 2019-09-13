import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin AppTheme on Model {
  final List<Color> themes = [
    Color(0xFF000000),
    Color(0xFF82A2FF),
    Color(0xFFFC4145),
    Color(0xFF535D80),
    Color(0xFFFDD32A),
    Color(0xFF00E676),
    Color(0xFFFF4081),
  ];

  int _selectedIndex = 1;
  SharedPreferences prefs;

  Future<Null> setAppTheme() async {
    prefs = await SharedPreferences.getInstance();
    _selectedIndex = prefs.getInt('selectedIndex') ?? 1;
    notifyListeners();
    return null;
  }

  Color get selectdTheme => themes[_selectedIndex];

  void selectTheme(int index) {
    _selectedIndex = index;
    notifyListeners();
    prefs.setInt('selectedIndex', index);
  }
}
